import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderly/core/storage/auth_storage.dart';

final authProvider =
    AsyncNotifierProvider<AuthNotifier, String?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    final token = await AuthStorage.getToken();
    return token;
  }

  Future<void> login(String token) async {
    await AuthStorage.saveToken(token);
    state = AsyncData(token);
  }

  Future<void> logout() async {
    await AuthStorage.clearToken();
    state = const AsyncData(null);
  }
}
