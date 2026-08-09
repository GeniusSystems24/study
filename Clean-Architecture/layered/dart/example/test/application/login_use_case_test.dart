import 'package:dart_layered_clean_architecture_example/src/application/dto/login_request.dart';
import 'package:dart_layered_clean_architecture_example/src/application/ports/token_service.dart';
import 'package:dart_layered_clean_architecture_example/src/application/usecases/login_use_case.dart';
import 'package:dart_layered_clean_architecture_example/src/domain/entities/user.dart';
import 'package:dart_layered_clean_architecture_example/src/domain/value_objects/email.dart';
import 'package:dart_layered_clean_architecture_example/src/infrastructure/repositories/in_memory_user_repository.dart';
import 'package:dart_layered_clean_architecture_example/src/infrastructure/security/simple_password_hasher.dart';
import 'package:test/test.dart';

final class FakeTokenService implements TokenService {
  @override
  Future<String> issue(Map<String, Object> claims) async => 'token-1';
}

void main() {
  test('LoginUseCase returns a token and public user data', () async {
    const passwordHasher = SimplePasswordHasher();
    final user = User(
      id: 'u-1',
      email: Email('anwar@example.com'),
      name: 'Anwar',
      passwordHash: await passwordHasher.hash('secret123'),
    );
    final useCase = LoginUseCase(
      userRepository: InMemoryUserRepository([user]),
      passwordHasher: passwordHasher,
      tokenService: FakeTokenService(),
    );

    final result = await useCase.execute(
      LoginRequest(email: 'anwar@example.com', password: 'secret123'),
    );

    expect(result.token, 'token-1');
    expect(result.user['email'], 'anwar@example.com');
  });
}
