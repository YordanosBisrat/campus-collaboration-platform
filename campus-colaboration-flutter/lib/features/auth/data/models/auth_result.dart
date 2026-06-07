// lib/features/auth/data/models/auth_result.dart

// FIX: import UserModel from the correct relative path within data/models/
import 'user_model.dart';

/// Sealed result returned by auth operations.
sealed class AuthResult {}

final class AuthSuccess extends AuthResult {
  final UserModel user;
  AuthSuccess(this.user);
}

final class AuthFailure extends AuthResult {
  final String message;
  AuthFailure(this.message);
}
