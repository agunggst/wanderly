import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wanderly/features/trip/data/trip_model.dart';

class FirestoreTripService {
  static final FirestoreTripService _instance = FirestoreTripService._internal();

  factory FirestoreTripService() {
    return _instance;
  }

  FirestoreTripService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'trips';

  /// Get all trips for a specific user
  Future<List<Trip>> getUserTrips(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Trip.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch trips: $e');
    }
  }

  /// Get a single trip by ID
  Future<Trip?> getTrip(String tripId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(tripId)
          .get();

      if (doc.exists) {
        return Trip.fromFirestore(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch trip: $e');
    }
  }

  /// Create a new trip
  Future<Trip> createTrip(Trip trip) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(trip.id)
          .set(trip.toFirestore());

      return trip;
    } catch (e) {
      throw Exception('Failed to create trip: $e');
    }
  }

  /// Update an existing trip
  Future<Trip> updateTrip(Trip trip) async {
    try {
      final updatedTrip = trip.copyWith(updatedAt: DateTime.now());
      
      await _firestore
          .collection(_collectionName)
          .doc(trip.id)
          .update(updatedTrip.toFirestore());

      return updatedTrip;
    } catch (e) {
      throw Exception('Failed to update trip: $e');
    }
  }

  /// Delete a trip
  Future<void> deleteTrip(String tripId) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(tripId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete trip: $e');
    }
  }

  /// Stream of user trips (real-time updates)
  Stream<List<Trip>> getUserTripsStream(String userId) {
    try {
      return _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Trip.fromFirestore(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('Failed to stream trips: $e');
    }
  }

  /// Batch delete all trips for a user (useful for account deletion)
  Future<void> deleteUserTrips(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete user trips: $e');
    }
  }
}
