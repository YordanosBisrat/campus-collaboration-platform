import '../../domain/entities/user_entity.dart';

/// Represents every possible auth state in the app.
sealed class AuthState {}

/// App just launched, checking for existing session
final class AuthLoading extends AuthState {}

/// No session found — user must log in
final class AuthUnauthenticated extends AuthState {}

/// User is fully logged in
final class AuthAuthenticated extends AuthState {
  final UserEntity user;
  AuthAuthenticated(this.user);
}

/// An auth operation (login/signup) is in progress
final class AuthOperationLoading extends AuthState {
  final UserEntity? previousUser;
  AuthOperationLoading({this.previousUser});
}

/// An auth operation failed
final class AuthError extends AuthState {
  final String message;
  final UserEntity? previousUser;
  AuthError(this.message, {this.previousUser});
}