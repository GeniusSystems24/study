class Failure {
  const Failure(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'Failure(code: $code, message: $message)';
}

class ApiException implements Exception {
  const ApiException(this.message, {this.code, this.statusCode});

  final String message;
  final String? code;
  final int? statusCode;
}
