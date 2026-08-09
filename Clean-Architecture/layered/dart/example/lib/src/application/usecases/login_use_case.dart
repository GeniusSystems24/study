import '../../domain/repositories/user_repository.dart';
import '../../domain/value_objects/email.dart';
import '../dto/login_request.dart';
import '../dto/login_response.dart';
import '../errors/application_exception.dart';
import '../ports/password_hasher.dart';
import '../ports/token_service.dart';

final class LoginUseCase {
  const LoginUseCase({
    required this.userRepository,
    required this.passwordHasher,
    required this.tokenService,
  });

  final UserRepository userRepository;
  final PasswordHasher passwordHasher;
  final TokenService tokenService;

  Future<LoginResponse> execute(LoginRequest request) async {
    final email = Email(request.email);
    final user = await userRepository.findByEmail(email);

    if (user == null) {
      throw const ApplicationException(
        'INVALID_CREDENTIALS',
        'Invalid credentials.',
        status: 401,
      );
    }

    user.assertCanLogin();
    final matches = await passwordHasher.verify(
      request.password,
      user.passwordHash,
    );

    if (!matches) {
      throw const ApplicationException(
        'INVALID_CREDENTIALS',
        'Invalid credentials.',
        status: 401,
      );
    }

    final token = await tokenService.issue({
      'sub': user.id,
      'email': user.email.value,
    });

    return LoginResponse(
      token: token,
      user: user.toPublicJson(),
    );
  }
}
