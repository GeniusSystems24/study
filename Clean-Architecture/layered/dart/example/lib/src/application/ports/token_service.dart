abstract interface class TokenService {
  Future<String> issue(Map<String, Object> claims);
}
