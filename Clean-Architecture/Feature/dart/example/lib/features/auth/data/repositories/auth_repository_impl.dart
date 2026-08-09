import '../../../../core/error/failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);
  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<AuthSession>> login({required String email, required String password}) async {
    try {
      final result = await _remoteDataSource.login(email: email, password: password);
      return Success(AuthSession(user: result.user.toEntity(), token: result.token));
    } on ApiException catch (error) {
      return FailureResult(Failure(error.message, code: error.code));
    } catch (_) {
      return const FailureResult(Failure('Unable to connect to the server'));
    }
  }
}
