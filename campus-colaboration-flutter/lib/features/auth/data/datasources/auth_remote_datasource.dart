import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:campus_collaboration_app/core/network/token_storage.dart';

class AuthRemoteDatasource {
  static const String _base = 'http://10.0.2.2:3000';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (TokenStorage.getToken() != null)
      'Authorization': 'Bearer ${TokenStorage.getToken()}',
  };

  Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String passwordHash,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'password': passwordHash,
      }),
    );
    if (res.statusCode != 201) {
      final err = jsonDecode(res.body);
      throw err['error'] ?? 'Registration failed.';
    }
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode != 200) {
      final err = jsonDecode(res.body);
      throw err['error'] ?? 'Login failed.';
    }
    return jsonDecode(res.body);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final res = await http.put(
      Uri.parse('$_base/auth/change-password'),
      headers: _headers,
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );
    if (res.statusCode != 200) {
      final err = jsonDecode(res.body);
      throw err['error'] ?? 'Failed to change password.';
    }
  }

  Future<void> requestPasswordReset(String email) async {
    await http.post(
      Uri.parse('$_base/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
  }

  Future<void> deleteAccount() async {
    final res = await http.delete(
      Uri.parse('$_base/auth/account'),
      headers: _headers,
    );
    if (res.statusCode != 200) {
      final err = jsonDecode(res.body);
      throw err['error'] ?? 'Failed to delete account.';
    }
  }
}
