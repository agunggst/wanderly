class User {
  final String email;
  final String password;
  final String fullName;

  const User({
    required this.email,
    required this.password,
    required this.fullName
  });

  User copyWith({
    String? email,
    String? password,
    String? fullName
  }) {
    return User(
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName
    );
  }
}