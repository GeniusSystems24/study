import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/usecases/login_user.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._loginUser);
  final LoginUser _loginUser;

  bool isLoading = false;
  String? errorMessage;
  AuthSession? session;

  Future<bool> login({required String email, required String password}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _loginUser(email: email, password: password);
    final didSucceed = result.fold(
      onFailure: (failure) {
        errorMessage = failure.message;
        return false;
      },
      onSuccess: (value) {
        session = value;
        return true;
      },
    );

    isLoading = false;
    notifyListeners();
    return didSucceed;
  }

  void logout() {
    session = null;
    errorMessage = null;
    notifyListeners();
  }
}
