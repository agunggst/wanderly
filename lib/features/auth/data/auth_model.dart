class Auth {
  final String accessToken;

  const Auth({
    required this.accessToken
  });

  Auth copyWith({
    String? accessToken
  }) {
    return Auth(
      accessToken: accessToken ?? this.accessToken
    );
  }
}