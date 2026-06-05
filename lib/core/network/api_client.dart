// lib/core/network/api_client.dart
//
// Shared mock API client.
// All remote datasources use this — swap _delay bodies for real HTTP
// calls (http/dio) when a backend is available. The interface stays identical.

library;

// ── Base exception ────────────────────────────────────────────────────────────

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

// ── Response wrapper ──────────────────────────────────────────────────────────

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int statusCode;

  const ApiResponse._({
    required this.success,
    this.data,
    this.error,
    required this.statusCode,
  });

  factory ApiResponse.ok(T data, {int statusCode = 200}) =>
      ApiResponse._(success: true, data: data, statusCode: statusCode);

  factory ApiResponse.fail(String error, {int statusCode = 400}) =>
      ApiResponse._(success: false, error: error, statusCode: statusCode);
}

// ── Mock HTTP client ──────────────────────────────────────────────────────────

class MockApiClient {
  MockApiClient._();
  static final MockApiClient instance = MockApiClient._();

  Future<void> _delay([int ms = 600]) =>
      Future.delayed(Duration(milliseconds: ms));

  // ── Auth ──────────────────────────────────────────────────────────────

  Future<ApiResponse<Map<String, dynamic>>> register({
    required String fullName,
    required String email,
    required String passwordHash,
  }) async {
    await _delay();
    // TODO: replace with real POST /api/auth/register
    return ApiResponse.ok({
      'success': true,
      'message': 'User registered successfully',
    }, statusCode: 201);
  }

  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    await _delay();
    // TODO: replace with real POST /api/auth/login
    return ApiResponse.ok({
      'success': true,
      'message': 'Login successful',
      'token': 'mock_jwt_${DateTime.now().millisecondsSinceEpoch}',
    });
  }

  Future<ApiResponse<void>> requestPasswordReset(String email) async {
    await _delay(400);
    // TODO: replace with real POST /api/auth/forgot-password
    return ApiResponse.ok(null);
  }

  // ── Skills ────────────────────────────────────────────────────────────

  Future<ApiResponse<List<Map<String, dynamic>>>> fetchSkills() async {
    await _delay();
    return ApiResponse.ok([]);
  }

  Future<ApiResponse<Map<String, dynamic>>> createSkill(
    Map<String, dynamic> payload,
  ) async {
    await _delay();
    return ApiResponse.ok({...payload, 'id': _fakeId()}, statusCode: 201);
  }

  Future<ApiResponse<Map<String, dynamic>>> updateSkill(
    String id,
    Map<String, dynamic> payload,
  ) async {
    await _delay();
    return ApiResponse.ok({...payload, 'id': id});
  }

  Future<ApiResponse<void>> deleteSkill(String id) async {
    await _delay();
    return ApiResponse.ok(null);
  }

  Future<ApiResponse<void>> requestSkill({
    required String skillId,
    required String requesterId,
  }) async {
    await _delay();
    return ApiResponse.ok(null, statusCode: 201);
  }

  // ── Groups ────────────────────────────────────────────────────────────

  Future<ApiResponse<List<Map<String, dynamic>>>> fetchGroups() async {
    await _delay();
    return ApiResponse.ok([]);
  }

  Future<ApiResponse<Map<String, dynamic>>> createGroup(
    Map<String, dynamic> payload,
  ) async {
    await _delay();
    return ApiResponse.ok({...payload, 'id': _fakeId()}, statusCode: 201);
  }

  Future<ApiResponse<Map<String, dynamic>>> updateGroup(
    String id,
    Map<String, dynamic> payload,
  ) async {
    await _delay();
    return ApiResponse.ok({...payload, 'id': id});
  }

  Future<ApiResponse<void>> deleteGroup(String id) async {
    await _delay();
    return ApiResponse.ok(null);
  }

  Future<ApiResponse<void>> joinGroup({
    required String groupId,
    required String userId,
  }) async {
    await _delay();
    return ApiResponse.ok(null, statusCode: 201);
  }

  Future<ApiResponse<void>> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    await _delay();
    return ApiResponse.ok(null);
  }

  // ── Helper ────────────────────────────────────────────────────────────

  String _fakeId() => DateTime.now().millisecondsSinceEpoch.toRadixString(16);
}
