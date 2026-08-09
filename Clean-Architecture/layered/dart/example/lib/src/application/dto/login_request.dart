import '../errors/application_exception.dart';

final class LoginRequest {
  LoginRequest({required String email, required String password})
      : email = email.trim().toLowerCase(),
        password = password {
    if (this.email.isEmpty || this.password.isEmpty) {
      throw const ApplicationException(
        'INVALID_LOGIN_REQUEST',
        'Email and password are required.',
        status: 422,
      );
    }
  }

  factory LoginRequest.fromJson(Map<String, Object?> json) {
    return LoginRequest(
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
    );
  }

  final String email;
  final String password;
}
