final class ApplicationException implements Exception {
  const ApplicationException(
    this.code,
    this.message, {
    this.status = 400,
    this.details,
  });

  final String code;
  final String message;
  final int status;
  final Object? details;

  @override
  String toString() => 'ApplicationException($code): $message';
}
