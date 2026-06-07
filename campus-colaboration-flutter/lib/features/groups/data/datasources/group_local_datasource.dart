// lib/features/groups/data/datasources/group_local_datasource.dart
// SQLite datasource using the shared AppDatabase singleton from core/database/.
// Works with study_groups and group_members tables defined in app_database.dart.

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../models/group_model.dart';

class GroupLocalDatasource {
  final _uuid = const Uuid();

  Future<Database> get _db => AppDatabase.instance.database;

  // ── study_groups table ────────────────────────────────────────────────────

  Future<List<GroupModel>> getAllGroups() async {
    final db = await _db;
    final rows = await db.query('study_groups', orderBy: 'created_at DESC');
    return rows.map(GroupModel.fromMap).toList();
  }

  Future<List<GroupModel>> getMyGroups(String userId) async {
    final db = await _db;
    // Get all group_ids where the user is a member
    final memberRows = await db.query(
      'group_members',
      columns: ['group_id'],
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    if (memberRows.isEmpty) return [];

    final groupIds = memberRows.map((r) => r['group_id'] as String).toList();
    final placeholders = List.filled(groupIds.length, '?').join(',');
    final rows = await db.query(
      'study_groups',
      where: 'id IN ($placeholders)',
      whereArgs: groupIds,
      orderBy: 'created_at DESC',
    );
    return rows.map(GroupModel.fromMap).toList();
  }

  Future<GroupModel?> getGroupById(String id) async {
    final db = await _db;
    final rows = await db.query(
      'study_groups',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return GroupModel.fromMap(rows.first);
  }

  Future<void> insertGroup(GroupModel model) async {
    final db = await _db;
    await db.insert(
      'study_groups',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateGroup(GroupModel model) async {
    final db = await _db;
    await db.update(
      'study_groups',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> updateMemberCount(String groupId, int delta) async {
    final db = await _db;
    await db.rawUpdate(
      'UPDATE study_groups SET member_count = member_count + ? WHERE id = ?',
      [delta, groupId],
    );
  }

  Future<void> deleteGroup(String groupId) async {
    final db = await _db;
    // Delete group and all its members in a transaction
    await db.transaction((txn) async {
      await txn.delete(
        'group_members',
        where: 'group_id = ?',
        whereArgs: [groupId],
      );
      await txn.delete(
        'study_groups',
        where: 'id = ?',
        whereArgs: [groupId],
      );
    });
  }

  Future<void> cacheGroups(List<GroupModel> groups) async {
    final db = await _db;
    final batch = db.batch();
    for (final g in groups) {
      batch.insert(
        'study_groups',
        g.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // ── group_members table ───────────────────────────────────────────────────

  Future<List<GroupMemberModel>> getGroupMembers(String groupId) async {
    final db = await _db;
    final rows = await db.query(
      'group_members',
      where: 'group_id = ?',
      whereArgs: [groupId],
      orderBy: 'joined_at ASC',
    );
    return rows.map(GroupMemberModel.fromMap).toList();
  }

  Future<bool> isMember({
    required String groupId,
    required String userId,
  }) async {
    final db = await _db;
    final rows = await db.query(
      'group_members',
      where: 'group_id = ? AND user_id = ?',
      whereArgs: [groupId, userId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<void> insertMember(GroupMemberModel model) async {
    final db = await _db;
    await db.insert(
      'group_members',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore, // no duplicate joins
    );
  }

  Future<void> deleteMember({
    required String groupId,
    required String userId,
  }) async {
    final db = await _db;
    await db.delete(
      'group_members',
      where: 'group_id = ? AND user_id = ?',
      whereArgs: [groupId, userId],
    );
  }

  Future<void> cacheMembers(List<GroupMemberModel> members) async {
    final db = await _db;
    final batch = db.batch();
    for (final m in members) {
      batch.insert(
        'group_members',
        m.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// Generate a new UUID for member rows
  String generateMemberId() => _uuid.v4();
}