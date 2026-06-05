// lib/features/profile/data/datasources/profile_local_datasource.dart

import '../../../../core/database/app_database.dart';
import '../models/profile_model.dart';

class ProfileLocalDatasource {
  final AppDatabase _db = AppDatabase.instance;

  Future<ProfileModel?> getProfile(String userId) async {
    final db = await _db.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return ProfileModel.fromMap(result.first);
  }

  Future<void> updateProfile(ProfileModel profile) async {
    final db = await _db.database;
    await db.update(
      'users',
      {
        'full_name': profile.fullName,
        'email': profile.email,
        'bio': profile.bio,
        'avatar_path': profile.avatarPath,
        // FIX: store created_at as INTEGER milliseconds (not ISO string)
        'created_at': profile.createdAt.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  // FIX: added — needed by profile_repository_impl to verify old password
  Future<String?> getPasswordHash(String userId) async {
    final db = await _db.database;
    final rows = await db.query(
      'users',
      columns: ['password_hash'],
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['password_hash'] as String?;
  }

  Future<void> changePassword(String userId, String hashedNewPassword) async {
    final db = await _db.database;
    await db.update(
      'users',
      {'password_hash': hashedNewPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
