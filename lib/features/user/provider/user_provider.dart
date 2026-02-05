import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user_model.dart';

final userProvider =
    NotifierProvider<UserController, User?>(UserController.new);

class UserController extends Notifier<User?> {

  @override
  User? build() {
    return null;
  }

  void setUser(User user) {
    state = user;
  }

  void updateUser({
    String? email,
    String? password,
    String? fullName,
  }) {
    if (state == null) return;

    state = state!.copyWith(
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  void clearUser() {
    state = null;
  }

  bool get isLoggedIn => state != null;
}
