import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/value_objects/email.dart';

final class InMemoryUserRepository implements UserRepository {
  InMemoryUserRepository([Iterable<User> initialUsers = const []])
      : _users = {for (final user in initialUsers) user.id: user};

  final Map<String, User> _users;

  @override
  Future<User?> findByEmail(Email email) async {
    for (final user in _users.values) {
      if (user.email == email) return user;
    }
    return null;
  }

  @override
  Future<User?> findById(String id) async => _users[id];
}
