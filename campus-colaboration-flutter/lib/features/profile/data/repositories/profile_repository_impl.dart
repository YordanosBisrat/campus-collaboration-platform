// lib/features/profile/data/repositories/profile_repository_impl.dart

import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDatasource local;
  final ProfileRemoteDatasource remote;

  ProfileRepositoryImpl({required this.local, required this.remote});

  String _hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  @override
  Future<ProfileEntity?> getProfile(String userId) async {
    try {
      final cached = await local.getProfile(userId);
      if (cached != null) return cached;
      final fromRemote = await remote.getProfile(userId);
      if (fromRemote != null) {
        await local.updateProfile(fromRemote);
        return fromRemote;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    final model = ProfileModel.fromEntity(profile);
    await local.updateProfile(model);
    await remote.updateProfile(model);
  }

  @override
  Future<void> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  ) async {
    // FIX: verify the old password before allowing the change
    final storedHash = await local.getPasswordHash(userId);
    if (storedHash == null) {
      throw Exception('User not found.');
    }
    if (storedHash != _hash(oldPassword)) {
      throw Exception('Current password is incorrect.');
    }
    await local.changePassword(userId, _hash(newPassword));
  }
}
