import 'package:clean_architecture_feature_based_flutter_example/core/result/result.dart';
import 'package:clean_architecture_feature_based_flutter_example/features/auth/domain/entities/auth_session.dart';
import 'package:clean_architecture_feature_based_flutter_example/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_feature_based_flutter_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:clean_architecture_feature_based_flutter_example/features/auth/domain/usecases/login_user.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRepository implements AuthRepository {
  String? capturedEmail;

  @override
  Future<Result<AuthSession>> login({required String email, required String password}) async {
    capturedEmail = email;
    return const Success(AuthSession(
      user: User(id: '1', name: 'Anwar', email: 'anwar@example.com'),
      token: 'token',
    ));
  }
}

void main() {
  test('LoginUser normalizes email and delegates to repository', () async {
    final repository = FakeAuthRepository();
    final useCase = LoginUser(repository);
    final result = await useCase(
      email: ' ANWAR@EXAMPLE.COM ',
      password: 'password123',
    );

    expect(repository.capturedEmail, 'anwar@example.com');
    expect(result, isA<Success<AuthSession>>());
  });
}
