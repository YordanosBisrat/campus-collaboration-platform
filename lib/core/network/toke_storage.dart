class TokenStorage {
  static String? _token;

  static void saveToken(String token) {
    _token = token;
  }

  static String? getToken() {
    return _token;
  }

  static void clearToken() {
    _token = null;
  }
}
