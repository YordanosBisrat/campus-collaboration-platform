import '../entities/user_entity.dart';

/// Abstract contract — the domain layer only knows this interface.
/// The data layer provides the concrete implementation.
abstract class AuthRepository {
  /// Returns the currently logged-in user, or null if not logged in.
  Future<UserEntity?> getCurrentUser();

  /// Sign up a new user. Throws [String] message on failure.
  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  /// Log in an existing user. Throws [String] message on failure.
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  /// Log out and clear session.
  Future<void> logout();

  /// Trigger password reset flow. Never throws (silent for security).
  Future<void> sendPasswordResetEmail(String email);

  /// Change password for authenticated user. Throws [String] on failure.
  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });

  /// Update profile details. Returns updated entity.
  Future<UserEntity> updateProfile({
    required String userId,
    required String fullName,
    required String email,
  });
}