import 'dart:convert';

import '../../application/ports/password_hasher.dart';

final class SimplePasswordHasher implements PasswordHasher {
  const SimplePasswordHasher();

  @override
  Future<String> hash(String plainText) async {
    final bytes = utf8.encode(plainText);
    var value = 2166136261;
    for (final byte in bytes) {
      value ^= byte;
      value = (value * 16777619) & 0xffffffff;
    }
    return value.toRadixString(16).padLeft(8, '0');
  }

  @override
  Future<bool> verify(String plainText, String hash) async {
    return await this.hash(plainText) == hash;
  }
}
