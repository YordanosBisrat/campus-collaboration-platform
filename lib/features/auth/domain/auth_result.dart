import 'user_model.dart';

/// Sealed-style result returned by every auth operation.
/// Use pattern matching:  switch(result) { case AuthSuccess(:final user) ... }
sealed class AuthResult {}

final class AuthSuccess extends AuthResult {
  final UserModel user;
  AuthSuccess(this.user);
}

final class AuthFailure extends AuthResult {
  final String message;
  AuthFailure(this.message);
}
