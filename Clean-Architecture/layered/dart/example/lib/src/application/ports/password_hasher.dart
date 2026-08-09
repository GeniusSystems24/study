abstract interface class PasswordHasher {
  Future<String> hash(String plainText);
  Future<bool> verify(String plainText, String hash);
}
