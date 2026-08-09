import 'dart:convert';
import 'dart:io';

import '../../application/errors/application_exception.dart';

Future<Map<String, Object?>> readJsonBody(HttpRequest request) async {
  try {
    final content = await utf8.decoder.bind(request).join();
    if (content.trim().isEmpty) return <String, Object?>{};
    final decoded = jsonDecode(content);
    if (decoded is! Map) {
      throw const ApplicationException(
        'INVALID_JSON',
        'JSON body must be an object.',
        status: 400,
      );
    }
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  } on FormatException {
    throw const ApplicationException(
      'INVALID_JSON',
      'Request body must contain valid JSON.',
      status: 400,
    );
  }
}

Future<void> sendJson(
  HttpResponse response,
  int status,
  Object body,
) async {
  response.statusCode = status;
  response.headers.contentType = ContentType.json;
  response.write(jsonEncode(body));
  await response.close();
}
