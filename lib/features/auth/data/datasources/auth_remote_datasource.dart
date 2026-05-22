
/// Mock remote datasource.
/// In production: replace method bodies with real HTTP calls.
/// Called by AuthRepositoryImpl ONLY on cache miss.
class AuthRemoteDatasource {
  /// Simulate network latency
  Future<void> _delay() =>
      Future.delayed(const Duration(milliseconds: 600));

  /// Mock: "register" user on remote server.
  /// Returns a fake server-assigned ID (in real app: server returns user JSON).
  Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String passwordHash,
  }) async {
    await _delay();
    // Mock success — real app: POST /api/auth/register
    return {
      'success': true,
      'message': 'User registered successfully',
    };
  }

  /// Mock: "login" on remote server.
  /// In real app: POST /api/auth/login → returns JWT token + user data.
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    await _delay();
    // Mock success — real app: POST /api/auth/login
    return {
      'success': true,
      'message': 'Login successful',
    };
  }

  /// Mock: send password reset email.
  /// Real app: POST /api/auth/forgot-password
  Future<void> requestPasswordReset(String email) async {
    await _delay();
    // No-op for mock
  }
}