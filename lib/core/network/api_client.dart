/// Shared API client infrastructure.
///
/// In this project the backend is mocked locally (no internet required).
/// Replace [_MockHttpClient._request] with real HTTP calls when a real
/// backend is available — all callers stay the same.
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

/// A mock HTTP client that simulates network latency.
/// Swap [_baseUrl] and implement real [get] / [post] / [put] / [delete]
/// using the `http` or `dio` package when a real API is ready.
class MockApiClient {
  MockApiClient._();
  static final MockApiClient instance = MockApiClient._();

  /// Simulates network round-trip delay (~600 ms).
  Future<void> _delay([int ms = 600]) =>
      Future.delayed(Duration(milliseconds: ms));

  // ── Auth endpoints ────────────────────────────────────────────────────

  Future<ApiResponse<Map<String, dynamic>>> register({
    required String fullName,
    required String email,
    required String passwordHash,
  }) async {
    await _delay();
    // Mock success — replace with: POST /api/auth/register
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
    // Mock success — replace with: POST /api/auth/login
    return ApiResponse.ok({
      'success': true,
      'message': 'Login successful',
      'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
    });
  }

  Future<ApiResponse<void>> requestPasswordReset(String email) async {
    await _delay(400);
    // Mock success — replace with: POST /api/auth/forgot-password
    return ApiResponse.ok(null);
  }

  // ── Skills endpoints ──────────────────────────────────────────────────

  Future<ApiResponse<List<Map<String, dynamic>>>> fetchSkills() async {
    await _delay();
    // Mock — replace with: GET /api/skills
    return ApiResponse.ok([]);
  }

  Future<ApiResponse<Map<String, dynamic>>> createSkill(
    Map<String, dynamic> payload,
  ) async {
    await _delay();
    // Mock — replace with: POST /api/skills
    return ApiResponse.ok({...payload, 'id': _fakeId()}, statusCode: 201);
  }

  Future<ApiResponse<Map<String, dynamic>>> updateSkill(
    String id,
    Map<String, dynamic> payload,
  ) async {
    await _delay();
    // Mock — replace with: PUT /api/skills/:id
    return ApiResponse.ok({...payload, 'id': id});
  }

  Future<ApiResponse<void>> deleteSkill(String id) async {
    await _delay();
    // Mock — replace with: DELETE /api/skills/:id
    return ApiResponse.ok(null);
  }

  Future<ApiResponse<void>> requestSkill({
    required String skillId,
    required String requesterId,
  }) async {
    await _delay();
    // Mock — replace with: POST /api/skills/:id/requests
    return ApiResponse.ok(null, statusCode: 201);
  }

  // ── Groups endpoints ──────────────────────────────────────────────────

  Future<ApiResponse<List<Map<String, dynamic>>>> fetchGroups() async {
    await _delay();
    // Mock — replace with: GET /api/groups
    return ApiResponse.ok([]);
  }

  Future<ApiResponse<Map<String, dynamic>>> createGroup(
    Map<String, dynamic> payload,
  ) async {
    await _delay();
    // Mock — replace with: POST /api/groups
    return ApiResponse.ok({...payload, 'id': _fakeId()}, statusCode: 201);
  }

  Future<ApiResponse<Map<String, dynamic>>> updateGroup(
    String id,
    Map<String, dynamic> payload,
  ) async {
    await _delay();
    // Mock — replace with: PUT /api/groups/:id
    return ApiResponse.ok({...payload, 'id': id});
  }

  Future<ApiResponse<void>> deleteGroup(String id) async {
    await _delay();
    // Mock — replace with: DELETE /api/groups/:id
    return ApiResponse.ok(null);
  }

  Future<ApiResponse<void>> joinGroup({
    required String groupId,
    required String userId,
  }) async {
    await _delay();
    // Mock — replace with: POST /api/groups/:id/members
    return ApiResponse.ok(null, statusCode: 201);
  }

  Future<ApiResponse<void>> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    await _delay();
    // Mock — replace with: DELETE /api/groups/:id/members/:userId
    return ApiResponse.ok(null);
  }

  // ── Helpers ───────────────────────────────────────────────────────────

  String _fakeId() => DateTime.now().millisecondsSinceEpoch.toRadixString(16);
}
