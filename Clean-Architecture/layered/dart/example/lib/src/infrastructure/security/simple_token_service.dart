import 'dart:convert';

import '../../application/ports/token_service.dart';

final class SimpleTokenService implements TokenService {
  SimpleTokenService({required this.secret, DateTime Function()? clock})
      : clock = clock ?? (() => DateTime.now().toUtc());

  final String secret;
  final DateTime Function() clock;

  @override
  Future<String> issue(Map<String, Object> claims) async {
    final payload = {
      ...claims,
      'iat': clock().millisecondsSinceEpoch ~/ 1000,
      'secretHint': secret.length,
    };
    return base64Url.encode(utf8.encode(jsonEncode(payload))).replaceAll('=', '');
  }
}
