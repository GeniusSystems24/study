final class LoginResponse {
  const LoginResponse({required this.token, required this.user});

  final String token;
  final Map<String, Object> user;

  Map<String, Object> toJson() => {
        'token': token,
        'user': user,
      };
}
