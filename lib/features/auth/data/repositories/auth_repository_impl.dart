import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Concrete implementation of [AuthRepository].
///
/// Strategy (cache-first):
/// 1. Check SQLite local cache first
/// 2. On cache miss → call remote datasource
/// 3. Persist remote result to local cache
/// 4. Return domain entity
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource _local;
  final AuthRemoteDatasource _remote;
  final _uuid = const Uuid();

  AuthRepositoryImpl({
    required AuthLocalDatasource local,
    required AuthRemoteDatasource remote,
  })  : _local = local,
        _remote = remote;

  // ── Hash helper ───────────────────────────────────────────────────────

  String _hash(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // ── getCurrentUser ────────────────────────────────────────────────────

  @override
  Future<UserEntity?> getCurrentUser() async {
    // Always check local cache — session table
    return _local.getSessionUser();
  }

  // ── signUp ────────────────────────────────────────────────────────────

  @override
  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.toLowerCase().trim();

    // 1. Cache check — email already registered?
    final existing = await _local.getUserByEmail(normalizedEmail);
    if (existing != null) {
      throw 'An account with this email already exists.';
    }

    // 2. Validate university email
    if (!normalizedEmail.contains('.edu') &&
        !normalizedEmail.contains('@university') &&
        !normalizedEmail.contains('@aau')) {
      throw 'Please use a valid university email address.';
    }

    final passwordHash = _hash(password);

    // 3. Cache miss → call remote (mock)
    await _remote.registerUser(
      fullName: fullName.trim(),
      email: normalizedEmail,
      passwordHash: passwordHash,
    );

    // 4. Build model and save to local cache
    final user = UserModel(
      id: _uuid.v4(),
      fullName: fullName.trim(),
      email: normalizedEmail,
      bio: '',
      avatarPath: '',
      createdAt: DateTime.now(),
    );

    await _local.insertUser(user, passwordHash);

    // 5. Save session
    await _local.saveSession(user);

    return user;
  }

  // ── login ─────────────────────────────────────────────────────────────

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.toLowerCase().trim();

    // 1. Cache check — find user by email
    final cached = await _local.getUserByEmail(normalizedEmail);

    if (cached == null) {
      // 2. Cache miss → try remote (mock: user not found)
      await _remote.loginUser(
          email: normalizedEmail, password: password);
      // Still no user locally — treat as not registered
      throw 'No account found with this email address.';
    }

    // 3. Cache hit — verify password locally
    final storedHash = await _local.getPasswordHash(cached.id);
    if (storedHash != _hash(password)) {
      throw 'Incorrect password. Please try again.';
    }

    // 4. Save session
    await _local.saveSession(cached);

    return cached;
  }

  // ── logout ────────────────────────────────────────────────────────────

  @override
  Future<void> logout() async {
    await _local.clearSession();
  }

  // ── sendPasswordResetEmail ────────────────────────────────────────────

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // Always succeeds silently (security: don't reveal if email exists)
    await _remote.requestPasswordReset(email.toLowerCase().trim());
  }

  // ── changePassword ────────────────────────────────────────────────────

  @override
  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final storedHash = await _local.getPasswordHash(userId);
    if (storedHash == null) throw 'User not found.';
    if (storedHash != _hash(currentPassword)) {
      throw 'Current password is incorrect.';
    }
    await _local.updatePasswordHash(userId, _hash(newPassword));
  }

  // ── updateProfile ─────────────────────────────────────────────────────

  @override
  Future<UserEntity> updateProfile({
    required String userId,
    required String fullName,
    required String email,
  }) async {
    return _local.updateProfile(userId, fullName, email);
  }
}