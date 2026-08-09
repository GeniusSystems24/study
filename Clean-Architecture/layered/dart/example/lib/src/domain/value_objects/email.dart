import '../errors/domain_exception.dart';

final class Email {
  Email(String value) : value = _validate(value);

  final String value;

  static String _validate(String raw) {
    final normalized = raw.trim().toLowerCase();
    final pattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!pattern.hasMatch(normalized)) {
      throw const DomainException(
        'INVALID_EMAIL',
        'A valid email address is required.',
      );
    }
    return normalized;
  }

  @override
  bool operator ==(Object other) => other is Email && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
