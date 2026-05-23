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
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  Future<void> changePassword(String userId, String hashedPassword) async {
    final db = await _db.database;
    await db.update(
      'users',
      {'password_hash': hashedPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
