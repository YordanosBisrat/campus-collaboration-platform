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
      String userId, String oldPassword, String newPassword) async {
    final hashedNew =
        sha256.convert(utf8.encode(newPassword)).toString();
    await local.changePassword(userId, hashedNew);
  }
}
