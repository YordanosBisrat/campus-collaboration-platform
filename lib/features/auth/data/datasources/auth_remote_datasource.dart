import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  static const String _base = 'http://10.0.2.2:3000';

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

  Future<void> requestPasswordReset(String email) async {
    await http.post(
      Uri.parse('$_base/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
  }
}
