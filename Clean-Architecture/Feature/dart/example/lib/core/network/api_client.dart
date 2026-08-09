import 'dart:convert';

import 'package:http/http.dart' as http;

import '../error/failure.dart';

class ApiClient {
  ApiClient({required this.baseUrl, required http.Client client}) : _client = client;

  final String baseUrl;
  final http.Client _client;

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = decoded['error'] as Map<String, dynamic>?;
      throw ApiException(
        error?['message'] as String? ?? 'Request failed',
        code: error?['code'] as String?,
        statusCode: response.statusCode,
      );
    }

    return decoded;
  }
}
