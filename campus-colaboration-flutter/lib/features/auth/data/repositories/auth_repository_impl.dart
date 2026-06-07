import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import 'package:campus_collaboration_app/core/network/token_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource _local;
  final AuthRemoteDatasource _remote;
  final _uuid = const Uuid();

  AuthRepositoryImpl({
    required AuthLocalDatasource local,
    required AuthRemoteDatasource remote,
  }) : _local = local,
       _remote = remote;

  String _hash(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _local.getSessionUser();
  }

  @override
  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.toLowerCase().trim();

    final response = await _remote.registerUser(
      fullName: fullName.trim(),
      email: normalizedEmail,
      passwordHash: password,
    );

    final token = response['token'] as String?;
    if (token != null) TokenStorage.saveToken(token);

    final userData = response['user'] as Map<String, dynamic>;
    final user = UserModel(
      id: userData['id'] as String,
      fullName: userData['fullName'] as String,
      email: userData['email'] as String,
      bio: userData['bio'] as String? ?? '',
      avatarPath: '',
      createdAt: DateTime.now(),
    );

    await _local.saveSession(user);
    return user;
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.toLowerCase().trim();

    final response = await _remote.loginUser(
      email: normalizedEmail,
      password: password,
    );

    final token = response['token'] as String?;
    if (token != null) TokenStorage.saveToken(token);

    final userData = response['user'] as Map<String, dynamic>;
    final user = UserModel(
      id: userData['id'] as String,
      fullName: userData['fullName'] as String,
      email: userData['email'] as String,
      bio: userData['bio'] as String? ?? '',
      avatarPath: '',
      createdAt: DateTime.now(),
    );

    await _local.saveSession(user);
    return user;
  }

  @override
  Future<void> logout() async {
    TokenStorage.clearToken();
    await _local.clearSession();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _remote.requestPasswordReset(email.toLowerCase().trim());
  }

  @override
  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    await _remote.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<UserEntity> updateProfile({
    required String userId,
    required String fullName,
    required String email,
  }) async {
    return _local.updateProfile(userId, fullName, email);
  }

  @override
  Future<void> deleteAccount(String userId) async {
    await _remote.deleteAccount();
    await _local.clearSession();
    TokenStorage.clearToken();
  }
}
