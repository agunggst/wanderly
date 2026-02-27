import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderly/core/services/firebase_auth_service.dart';
import 'package:wanderly/core/storage/auth_storage.dart';

final authProvider =
    AsyncNotifierProvider<AuthNotifier, String?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<String?> {
  late final FirebaseAuthService _firebaseAuthService;

  @override
  Future<String?> build() async {
    _firebaseAuthService = FirebaseAuthService();
    
    // Check if user is already authenticated
    if (_firebaseAuthService.isAuthenticated()) {
      final token = await _firebaseAuthService.getIdToken();
      if (token != null) {
        await AuthStorage.saveToken(token);
        return token;
      }
    }
    
    // Try to get token from local storage
    final token = await AuthStorage.getToken();
    return token;
  }

  /// Register a new user with Firebase
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final userCredential = await _firebaseAuthService.register(
        email: email,
        password: password,
        fullName: fullName,
      );
      
      final token = await userCredential.user?.getIdToken();
      if (token != null) {
        await AuthStorage.saveToken(token);
        state = AsyncData(token);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Login with Firebase
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final userCredential = await _firebaseAuthService.login(
        email: email,
        password: password,
      );
      
      final token = await userCredential.user?.getIdToken();
      if (token != null) {
        await AuthStorage.saveToken(token);
        state = AsyncData(token);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Logout from Firebase
  Future<void> logout() async {
    try {
      await _firebaseAuthService.logout();
      await AuthStorage.clearToken();
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}
