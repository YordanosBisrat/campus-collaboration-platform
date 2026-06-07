import 'package:sqflite/sqflite.dart';
import '../../../../core/database/app_database.dart';
import '../models/user_model.dart';

/// Handles ALL SQLite read/write for auth.
/// Called by AuthRepositoryImpl — never directly by providers.
class AuthLocalDatasource {
  Future<Database> get _db => AppDatabase.instance.database;

  // ── Read ──────────────────────────────────────────────────────────────

  /// Returns user by email, or null (cache miss)
  Future<UserModel?> getUserByEmail(String email) async {
    final db = await _db;
    final rows = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.toLowerCase().trim()],
    );
    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  /// Returns user by id, or null
  Future<UserModel?> getUserById(String id) async {
    final db = await _db;
    final rows = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  /// Returns password hash for a given user id
  Future<String?> getPasswordHash(String userId) async {
    final db = await _db;
    final rows = await db.query(
      'users',
      columns: ['password_hash'],
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (rows.isEmpty) return null;
    return rows.first['password_hash'] as String;
  }

  /// Returns current session user, or null if not logged in
  Future<UserModel?> getSessionUser() async {
    final db = await _db;
    final sessions = await db.query('session', limit: 1);
    if (sessions.isEmpty) return null;
    final userId = sessions.first['user_id'] as String;
    return getUserById(userId);
  }

  // ── Write ─────────────────────────────────────────────────────────────

  /// Insert new user row (including password hash)
  Future<void> insertUser(UserModel user, String passwordHash) async {
    final db = await _db;
    await db.insert(
      'users',
      {...user.toMap(), 'password_hash': passwordHash},
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  /// Save session (replaces any existing session)
  Future<void> saveSession(UserModel user) async {
    final db = await _db;
    await db.delete('session');
    await db.insert('session', {
      'user_id': user.id,
      'user_email': user.email,
      'user_name': user.fullName,
      'logged_in_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Clear session row (logout)
  Future<void> clearSession() async {
    await AppDatabase.instance.clearSession();
  }

  /// Update password hash
  Future<void> updatePasswordHash(
      String userId, String newHash) async {
    final db = await _db;
    await db.update(
      'users',
      {'password_hash': newHash},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Update profile fields
  Future<UserModel> updateProfile(
      String userId, String fullName, String email) async {
    final db = await _db;
    await db.update(
      'users',
      {
        'full_name': fullName.trim(),
        'email': email.toLowerCase().trim(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
    // Refresh session display name/email
    await db.update('session', {
      'user_name': fullName.trim(),
      'user_email': email.toLowerCase().trim(),
    });
    return (await getUserById(userId))!;
  }
}