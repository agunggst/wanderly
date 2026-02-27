# Firebase Authentication Setup Guide

This guide will help you set up Firebase Authentication for the Wanderly Flutter project.

## Prerequisites

- Flutter SDK installed
- Firebase project created at [Firebase Console](https://console.firebase.google.com)
- FlutterFire CLI installed (`dart pub global activate flutterfire_cli`)

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a new project"
3. Enter project name: `wanderly-project`
4. Follow the setup wizard

## Step 2: Configure Firebase for Your Platform

### For Android:

1. In Firebase Console, go to Project Settings
2. Add Android app with package name: `com.example.wanderly`
3. Download `google-services.json`
4. Place it in `android/app/`

### For iOS:

1. In Firebase Console, go to Project Settings
2. Add iOS app with bundle ID: `com.example.wanderly`
3. Download `GoogleService-Info.plist`
4. Open `ios/Runner.xcworkspace` in Xcode
5. Add the plist file to the Runner project

### For Web:

1. In Firebase Console, go to Project Settings
2. Add Web app
3. Copy the Firebase config

## Step 3: Update Firebase Options

Edit `lib/firebase_options.dart` and replace the dummy values with your actual Firebase credentials:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: '1:YOUR_PROJECT_NUMBER:android:YOUR_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_STORAGE_BUCKET',
);

// Do the same for iOS, macOS, and web
```

## Step 4: Enable Email/Password Authentication

1. In Firebase Console, go to Authentication
2. Click "Sign-in method"
3. Enable "Email/Password"

## Step 5: Install Dependencies

```bash
flutter pub get
```

## Step 6: Run the App

```bash
flutter run
```

## Features Implemented

### 1. **User Registration**
- Users can create a new account with email and password
- Password validation (minimum 6 characters)
- Email format validation
- Full name required
- Error handling with user-friendly messages

### 2. **User Login**
- Users can login with email and password
- Session persistence using local storage
- Automatic redirect to home screen on successful login
- Error handling for invalid credentials

### 3. **User Logout**
- Logout button in the app bar (top right)
- Confirmation dialog before logout
- Automatic redirect to login screen
- Session cleared from local storage and Firebase

### 4. **Authentication State Management**
- Uses Riverpod for state management
- Automatic token refresh
- Protected routes (redirects to login if not authenticated)
- Persistent authentication across app restarts

## File Structure

```
lib/
├── core/
│   ├── services/
│   │   └── firebase_auth_service.dart    # Firebase Auth service
│   ├── storage/
│   │   └── auth_storage.dart             # Local token storage
│   └── router/
│       └── router.dart                   # Route protection
├── features/
│   ├── auth/
│   │   ├── provider/
│   │   │   └── auth_provider.dart        # Auth state management
│   │   └── view/
│   │       └── screens/
│   │           ├── login_screen.dart     # Login UI
│   │           └── register_screen.dart  # Register UI
│   └── user/
│       ├── provider/
│       │   └── user_provider.dart        # User data management
│       └── data/
│           └── user_model.dart           # User model
├── shared/
│   └── widgets/
│       └── custom_app_bar.dart           # App bar with logout
└── firebase_options.dart                 # Firebase configuration
```

## API Reference

### FirebaseAuthService

```dart
// Register new user
await FirebaseAuthService().register(
  email: 'user@example.com',
  password: 'password123',
  fullName: 'John Doe',
);

// Login
await FirebaseAuthService().login(
  email: 'user@example.com',
  password: 'password123',
);

// Logout
await FirebaseAuthService().logout();

// Get current user
final user = FirebaseAuthService().getCurrentUser();

// Check if authenticated
final isAuth = FirebaseAuthService().isAuthenticated();
```

### AuthProvider (Riverpod)

```dart
// Register
await ref.read(authProvider.notifier).register(
  email: 'user@example.com',
  password: 'password123',
  fullName: 'John Doe',
);

// Login
await ref.read(authProvider.notifier).login(
  email: 'user@example.com',
  password: 'password123',
);

// Logout
await ref.read(authProvider.notifier).logout();

// Watch auth state
final authState = ref.watch(authProvider);
```

## Error Handling

The app handles the following Firebase Auth errors:

- `weak-password`: Password is too weak
- `email-already-in-use`: Email already registered
- `invalid-email`: Invalid email format
- `user-disabled`: User account disabled
- `user-not-found`: User not found
- `wrong-password`: Incorrect password
- `too-many-requests`: Too many login attempts

All errors are displayed to the user via SnackBar notifications.

## Testing

### Test Account
You can create test accounts in Firebase Console under Authentication > Users

### Test Credentials
```
Email: test@example.com
Password: Test123456
```

## Troubleshooting

### Firebase not initializing
- Ensure `firebase_options.dart` has correct credentials
- Check that Firebase project is properly configured
- Verify internet connection

### Authentication fails
- Check email/password are correct
- Ensure Email/Password auth is enabled in Firebase Console
- Check Firebase project rules and permissions

### Token not persisting
- Verify `shared_preferences` is properly initialized
- Check app permissions for local storage
- Clear app cache and reinstall

## Next Steps

1. **Google Sign-In**: Implement Google authentication
2. **Password Reset**: Add forgot password functionality
3. **Email Verification**: Add email verification on registration
4. **Social Auth**: Add more social login options
5. **User Profile**: Create user profile management screen

## Support

For issues or questions:
1. Check Firebase Console logs
2. Review Flutter console output
3. Check Firebase documentation: https://firebase.flutter.dev
