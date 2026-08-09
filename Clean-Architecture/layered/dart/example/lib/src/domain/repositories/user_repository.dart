import '../entities/user.dart';
import '../value_objects/email.dart';

abstract interface class UserRepository {
  Future<User?> findByEmail(Email email);
  Future<User?> findById(String id);
}
