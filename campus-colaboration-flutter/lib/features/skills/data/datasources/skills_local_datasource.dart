import 'package:sqflite/sqflite.dart';
import '../../../../core/database/app_database.dart';
import '../models/skill_model.dart';

class SkillsLocalDatasource {
  Future<List<SkillModel>> getAllSkills() async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query('skills', orderBy: 'created_at DESC');
    return rows.map(SkillModel.fromMap).toList();
  }

  Future<List<SkillModel>> getSkillsByOwner(String ownerId) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'skills',
      where: 'owner_id = ?',
      whereArgs: [ownerId],
      orderBy: 'created_at DESC',
    );
    return rows.map(SkillModel.fromMap).toList();
  }

  Future<SkillModel?> getSkillById(String id) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'skills',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return SkillModel.fromMap(rows.first);
  }

  Future<void> insertSkill(SkillModel skill) async {
    final db = await AppDatabase.instance.database;
    await db.insert(
      'skills',
      skill.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateSkill(SkillModel skill) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'skills',
      skill.toMap(),
      where: 'id = ?',
      whereArgs: [skill.id],
    );
  }

  Future<void> deleteSkill(String id) async {
    final db = await AppDatabase.instance.database;
    await db.delete('skills', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> cacheSkills(List<SkillModel> skills) async {
    final db = await AppDatabase.instance.database;
    final batch = db.batch();
    for (final s in skills) {
      batch.insert(
        'skills',
        s.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> insertSkillRequest({
    required String id,
    required String skillId,
    required String skillTitle,
    required String requesterId,
    required String requesterName,
  }) async {
    final db = await AppDatabase.instance.database;
    await db.insert('skill_requests', {
      'id': id,
      'skill_id': skillId,
      'skill_title': skillTitle,
      'requester_id': requesterId,
      'requester_name': requesterName,
      'status': 'pending',
      'created_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<bool> hasRequested(String skillId, String requesterId) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'skill_requests',
      where: 'skill_id = ? AND requester_id = ?',
      whereArgs: [skillId, requesterId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }
}
