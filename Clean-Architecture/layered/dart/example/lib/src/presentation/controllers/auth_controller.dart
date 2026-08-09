import 'dart:io';

import '../../application/dto/login_request.dart';
import '../../application/usecases/login_use_case.dart';
import '../http/json_io.dart';

final class AuthController {
  const AuthController({required this.loginUseCase});

  final LoginUseCase loginUseCase;

  Future<void> login(
    HttpRequest request,
    Map<String, String> _params,
  ) async {
    final body = await readJsonBody(request);
    final result = await loginUseCase.execute(LoginRequest.fromJson(body));
    await sendJson(request.response, HttpStatus.ok, result.toJson());
  }
}
