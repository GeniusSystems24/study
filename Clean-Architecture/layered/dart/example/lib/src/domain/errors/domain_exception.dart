final class DomainException implements Exception {
  const DomainException(this.code, this.message, {this.details});

  final String code;
  final String message;
  final Object? details;

  @override
  String toString() => 'DomainException($code): $message';
}
