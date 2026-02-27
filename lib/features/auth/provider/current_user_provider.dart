import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to get the current user ID
final currentUserIdProvider = Provider<String?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid;
});

/// Provider to get the current Firebase user
final currentUserProvider = Provider<User?>((ref) {
  return FirebaseAuth.instance.currentUser;
});
