import '../../../../core/result/result.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  const LoginUser(this._repository);
  final AuthRepository _repository;

  Future<Result<AuthSession>> call({required String email, required String password}) {
    return _repository.login(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }
}
