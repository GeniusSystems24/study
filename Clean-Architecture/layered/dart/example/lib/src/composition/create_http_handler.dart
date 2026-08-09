import 'dart:io';

import '../presentation/http/json_io.dart';
import '../presentation/http/router.dart';
import '../presentation/middleware/error_handler.dart';
import 'app_container.dart';

Future<void> Function(HttpRequest) createHttpHandler(AppContainer container) {
  final router = Router()
    ..register('POST', '/api/auth/login', container.authController.login)
    ..register('POST', '/api/orders', container.orderController.create)
    ..register('GET', '/api/orders/:id', container.orderController.getById);

  return (HttpRequest request) async {
    try {
      final match = router.match(request.method, request.uri.path);
      if (match == null) {
        await sendJson(request.response, HttpStatus.notFound, {
          'error': {
            'code': 'ROUTE_NOT_FOUND',
            'message': 'Route was not found.',
          },
        });
        return;
      }
      await match.handler(request, match.params);
    } catch (error, stackTrace) {
      stderr.writeln(stackTrace);
      await handleError(request.response, error);
    }
  };
}
