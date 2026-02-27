# Firestore Migration Guide

This guide explains how to migrate from Hive to Firebase Firestore for data storage in the Wanderly project.

## Overview

The project has been migrated from Hive (local database) to Firebase Firestore (cloud database). This provides:

- ✅ Real-time data synchronization across devices
- ✅ Automatic cloud backup
- ✅ Scalable cloud storage
- ✅ User-specific data isolation
- ✅ Offline support with Firestore caching

## Changes Made

### Dependencies Updated

**Removed:**
- `hive: ^2.2.3`
- `hive_flutter: ^1.1.0`
- `hive_generator: ^2.0.1`
- `build_runner: ^2.4.8`

**Added:**
- `cloud_firestore: ^5.0.0`

### Files Modified

1. **`lib/features/trip/data/trip_model.dart`**
   - Removed Hive annotations (`@HiveType`, `@HiveField`)
   - Added `userId` field for user-specific data
   - Added `createdAt` and `updatedAt` timestamps
   - Added `toFirestore()` method for serialization
   - Added `fromFirestore()` factory for deserialization

2. **`lib/core/storage/trip_storage.dart`**
   - Replaced with `lib/core/services/firestore_trip_service.dart`
   - Uses Firestore queries instead of Hive box operations

3. **`lib/features/trip/provider/trip_provider.dart`**
   - Updated to use `FirestoreTripService`
   - Uses `currentUserIdProvider` to get user ID
   - Implements proper async state management

4. **`lib/main.dart`**
   - Removed Hive initialization
   - Kept Firebase initialization

5. **`lib/features/trip/view/screens/manage_trip_modal.dart`**
   - Added `userId` when creating/updating trips
   - Gets current user from Firebase Auth

### New Files Created

1. **`lib/core/services/firestore_trip_service.dart`**
   - Singleton service for Firestore operations
   - Methods: `getUserTrips()`, `getTrip()`, `createTrip()`, `updateTrip()`, `deleteTrip()`
   - Stream support for real-time updates
   - Batch operations for bulk deletes

2. **`lib/features/auth/provider/current_user_provider.dart`**
   - Provides current user ID from Firebase Auth
   - Provides current Firebase user object

## Firestore Database Structure

### Collections

#### `trips` Collection

```
trips/
├── {tripId}
│   ├── id: string
│   ├── title: string
│   ├── date: string (date range as string)
│   ├── imageUrl: string
│   ├── status: string
│   ��── members: array<string>
│   ├── userId: string (document owner)
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp
```

### Security Rules

Add these Firestore security rules to ensure users can only access their own data:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own trips
    match /trips/{tripId} {
      allow read, write: if request.auth.uid == resource.data.userId;
      allow create: if request.auth.uid == request.resource.data.userId;
    }
  }
}
```

## Setup Instructions

### Step 1: Enable Firestore in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to **Firestore Database**
4. Click **Create Database**
5. Choose **Start in production mode**
6. Select your region (closest to your users)
7. Click **Create**

### Step 2: Set Firestore Security Rules

1. In Firebase Console, go to **Firestore Database**
2. Click **Rules** tab
3. Replace the default rules with the security rules above
4. Click **Publish**

### Step 3: Install Dependencies

```bash
flutter pub get
```

### Step 4: Run the App

```bash
flutter run
```

## API Reference

### FirestoreTripService

```dart
final service = FirestoreTripService();

// Get all trips for a user
final trips = await service.getUserTrips(userId);

// Get a single trip
final trip = await service.getTrip(tripId);

// Create a new trip
final newTrip = await service.createTrip(trip);

// Update a trip
final updated = await service.updateTrip(trip);

// Delete a trip
await service.deleteTrip(tripId);

// Stream real-time updates
service.getUserTripsStream(userId).listen((trips) {
  // Handle real-time updates
});

// Delete all trips for a user
await service.deleteUserTrips(userId);
```

### Trip Model

```dart
// Create a trip
final trip = Trip(
  title: 'Summer Vacation',
  date: 'Jun 1 - Jun 15, 2024',
  imageUrl: 'https://example.com/image.jpg',
  status: 'Planning',
  members: ['avatar1.jpg', 'avatar2.jpg'],
  userId: 'user123',
);

// Convert to Firestore
final data = trip.toFirestore();

// Create from Firestore
final trip = Trip.fromFirestore(data);
```

## Data Migration (If You Have Existing Hive Data)

If you have existing trips in Hive, you'll need to migrate them to Firestore:

```dart
// Example migration code
import 'package:wanderly/core/storage/trip_storage.dart';
import 'package:wanderly/core/services/firestore_trip_service.dart';

Future<void> migrateHiveToFirestore(String userId) async {
  // Get all trips from Hive
  final hiveTrips = await TripStorage.getAllTrips();
  
  // Create Firestore service
  final firestoreService = FirestoreTripService();
  
  // Migrate each trip
  for (final trip in hiveTrips) {
    final migratedTrip = trip.copyWith(userId: userId);
    await firestoreService.createTrip(migratedTrip);
  }
  
  // Clear Hive after successful migration
  await TripStorage.clear();
}
```

## Real-Time Updates

The app now supports real-time updates using Firestore streams:

```dart
// In your provider or widget
final tripsStream = FirestoreTripService().getUserTripsStream(userId);

tripsStream.listen((trips) {
  // Update UI with new trips
  print('Trips updated: ${trips.length}');
});
```

## Offline Support

Firestore automatically caches data locally. When offline:
- Users can still view previously loaded trips
- Changes are queued and synced when online
- No additional configuration needed

## Performance Considerations

### Indexing

For better query performance, Firestore will automatically suggest indexes. Accept these suggestions in the Firebase Console.

### Pagination

For large datasets, implement pagination:

```dart
Future<List<Trip>> getUserTripsPage(String userId, {int limit = 10}) async {
  final snapshot = await _firestore
      .collection('trips')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .limit(limit)
      .get();
  
  return snapshot.docs
      .map((doc) => Trip.fromFirestore(doc.data()))
      .toList();
}
```

## Troubleshooting

### Trips not appearing
- Check Firestore security rules
- Verify user is authenticated
- Check browser console for errors
- Ensure `userId` is set correctly

### Permission denied errors
- Review Firestore security rules
- Ensure user is authenticated
- Check that `userId` matches authenticated user

### Slow queries
- Add Firestore indexes (Firebase Console will suggest)
- Limit query results with `.limit()`
- Use pagination for large datasets

## Monitoring

Monitor Firestore usage in Firebase Console:
- **Firestore Database** → **Usage** tab
- Track read/write operations
- Monitor storage usage
- Set up billing alerts

## Cost Optimization

Firestore pricing is based on:
- **Reads**: 0.06 USD per 100,000 reads
- **Writes**: 0.18 USD per 100,000 writes
- **Deletes**: 0.02 USD per 100,000 deletes
- **Storage**: 0.18 USD per GB/month

Tips to reduce costs:
- Use pagination to limit reads
- Batch operations when possible
- Implement caching strategies
- Use Firestore security rules to prevent unauthorized access

## Next Steps

1. **User Profiles**: Store user data in Firestore
2. **Trip Sharing**: Implement trip sharing between users
3. **Real-time Collaboration**: Add real-time trip editing
4. **Offline Sync**: Implement offline-first architecture
5. **Analytics**: Track user behavior with Firebase Analytics

## Support

- Firestore Documentation: https://firebase.google.com/docs/firestore
- Flutter Firebase: https://firebase.flutter.dev
- Firestore Best Practices: https://firebase.google.com/docs/firestore/best-practices
