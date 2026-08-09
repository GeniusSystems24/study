import '../errors/domain_exception.dart';
import '../value_objects/email.dart';

final class User {
  User({
    required this.id,
    required Email email,
    required this.name,
    required this.passwordHash,
    this.active = true,
  }) : email = email {
    if (id.trim().isEmpty || name.trim().isEmpty || passwordHash.isEmpty) {
      throw const DomainException(
        'INVALID_USER',
        'User id, name, and password hash are required.',
      );
    }
  }

  final String id;
  final Email email;
  final String name;
  final String passwordHash;
  bool active;

  void deactivate() {
    active = false;
  }

  void assertCanLogin() {
    if (!active) {
      throw const DomainException(
        'USER_INACTIVE',
        'Inactive users cannot sign in.',
      );
    }
  }

  Map<String, Object> toPublicJson() => {
        'id': id,
        'email': email.value,
        'name': name,
        'active': active,
      };
}
