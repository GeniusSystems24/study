import 'dart:io';

import '../../application/errors/application_exception.dart';
import '../../domain/errors/domain_exception.dart';
import '../http/json_io.dart';

Future<void> handleError(HttpResponse response, Object error) async {
  if (error is ApplicationException) {
    await sendJson(response, error.status, {
      'error': {
        'code': error.code,
        'message': error.message,
        'details': error.details,
      },
    });
    return;
  }

  if (error is DomainException) {
    await sendJson(response, HttpStatus.unprocessableEntity, {
      'error': {
        'code': error.code,
        'message': error.message,
        'details': error.details,
      },
    });
    return;
  }

  stderr.writeln(error);
  await sendJson(response, HttpStatus.internalServerError, {
    'error': {
      'code': 'INTERNAL_ERROR',
      'message': 'An unexpected error occurred.',
    },
  });
}
