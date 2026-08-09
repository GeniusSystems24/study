import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRemoteResult {
  const AuthRemoteResult({required this.user, required this.token});
  final UserModel user;
  final String token;
}

abstract interface class AuthRemoteDataSource {
  Future<AuthRemoteResult> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<AuthRemoteResult> login({required String email, required String password}) async {
    final json = await _apiClient.post('/api/auth/login', {
      'email': email,
      'password': password,
    });
    final data = json['data'] as Map<String, dynamic>;
    return AuthRemoteResult(
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      token: data['token'] as String,
    );
  }
}
