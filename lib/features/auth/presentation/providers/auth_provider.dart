import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// ─────────────────────────────────────────────────────────
/// Datasource Providers
/// ─────────────────────────────────────────────────────────

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>(
  (ref) => AuthLocalDatasource(),
);

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>(
  (ref) => AuthRemoteDatasource(),
);

/// ─────────────────────────────────────────────────────────
/// Repository Provider
/// ─────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    local: ref.watch(authLocalDatasourceProvider),
    remote: ref.watch(authRemoteDatasourceProvider),
  ),
);

/// ─────────────────────────────────────────────────────────
/// Auth Notifier (Riverpod 3)
/// ─────────────────────────────────────────────────────────

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repo;

  @override
  AuthState build() {
    _repo = ref.watch(authRepositoryProvider);

    // Initial state
    _checkSession();

    return AuthLoading();
  }

  /// Check existing login session
  Future<void> _checkSession() async {
    try {
      final user = await _repo.getCurrentUser();

      if (user != null) {
        state = AuthAuthenticated(user);
      } else {
        state = AuthUnauthenticated();
      }
    } catch (_) {
      state = AuthUnauthenticated();
    }
  }

  /// ─────────────────────────────────────────────────────
  /// SIGN UP
  /// ─────────────────────────────────────────────────────

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = AuthOperationLoading();

    try {
      final user = await _repo.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );

      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// ─────────────────────────────────────────────────────
  /// LOGIN
  /// ─────────────────────────────────────────────────────

  Future<void> login({required String email, required String password}) async {
    state = AuthOperationLoading();

    try {
      final user = await _repo.login(email: email, password: password);

      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// ─────────────────────────────────────────────────────
  /// LOGOUT
  /// ─────────────────────────────────────────────────────

  Future<void> logout() async {
    await _repo.logout();
    state = AuthUnauthenticated();
  }

  /// ─────────────────────────────────────────────────────
  /// FORGOT PASSWORD
  /// ─────────────────────────────────────────────────────

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _repo.sendPasswordResetEmail(email);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// ─────────────────────────────────────────────────────
  /// CHANGE PASSWORD
  /// ─────────────────────────────────────────────────────

  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final current = state;

    if (current is! AuthAuthenticated) {
      return 'Not logged in.';
    }

    try {
      await _repo.changePassword(
        userId: current.user.id,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// ─────────────────────────────────────────────────────
  /// UPDATE PROFILE
  /// ─────────────────────────────────────────────────────

  Future<String?> updateProfile({
    required String fullName,
    required String email,
  }) async {
    final current = state;

    if (current is! AuthAuthenticated) {
      return 'Not logged in.';
    }

    try {
      final updated = await _repo.updateProfile(
        userId: current.user.id,
        fullName: fullName,
        email: email,
      );

      state = AuthAuthenticated(updated);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Clear error state
  void clearError() {
    state = AuthUnauthenticated();
  }
}

/// ─────────────────────────────────────────────────────────
/// Main Auth Provider
/// ─────────────────────────────────────────────────────────

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// ─────────────────────────────────────────────────────────
/// Convenience Providers
/// ─────────────────────────────────────────────────────────

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthAuthenticated;
});

final currentUserProvider = Provider<UserEntity?>((ref) {
  final state = ref.watch(authProvider);

  if (state is AuthAuthenticated) {
    return state.user;
  }

  return null;
});
