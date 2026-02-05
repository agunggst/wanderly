import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_model.dart';

final authProvider =
    NotifierProvider<AuthNotifier, Auth?>(AuthNotifier.new);

class AuthNotifier extends Notifier<Auth?> {

  @override
  Auth? build() {
    return null;
  }

  void login(String token) {
    state = Auth(accessToken: token);
  }

  void logout() {
    state = null;
  }

  void updateToken(String newToken) {
    if (state == null) return;

    state = state!.copyWith(
      accessToken: newToken,
    );
  }

  bool get isLoggedIn => state != null;
}
