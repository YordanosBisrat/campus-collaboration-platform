// lib/features/auth/data/datasources/auth_remote_datasource.dart
//
// Mock remote datasource — uses the shared MockApiClient from core/
// In production: replace MockApiClient calls with real HTTP (http/dio package)

import '../../../../core/network/api_client.dart';

class AuthRemoteDatasource {
  final MockApiClient _api = MockApiClient.instance;

  /// Mock register — simulates POST /api/auth/register
  Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String passwordHash,
  }) async {
    final response = await _api.register(
      fullName: fullName,
      email: email,
      passwordHash: passwordHash,
    );
    if (!response.success) {
      throw response.error ?? 'Registration failed.';
    }
    return response.data ?? {};
  }

  /// Mock login — simulates POST /api/auth/login
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await _api.login(email: email, password: password);
    if (!response.success) {
      throw response.error ?? 'Login failed.';
    }
    return response.data ?? {};
  }

  /// Mock forgot password — simulates POST /api/auth/forgot-password
  Future<void> requestPasswordReset(String email) async {
    await _api.requestPasswordReset(email);
    // Always silent — never reveal if email exists (security best practice)
  }
}
