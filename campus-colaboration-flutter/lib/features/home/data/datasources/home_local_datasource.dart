import '../../../../core/database/app_database.dart';
import '../models/activity_model.dart';

class HomeLocalDatasource {
  final AppDatabase _db = AppDatabase.instance;

  Future<List<ActivityModel>> getRecentActivity(String userId) async {
    try {
      final db = await _db.database;
      final skillRequests = await db.rawQuery(
        '''
        SELECT 
          sr.id,
          'Skill request from ' || u.full_name AS title,
          s.title AS subtitle,
          'skill' AS type,
          sr.created_at
        FROM skill_requests sr
        JOIN users u ON sr.requester_id = u.id
        JOIN skills s ON sr.skill_id = s.id
        WHERE s.owner_id = ?
        ORDER BY sr.created_at DESC
        LIMIT 5
      ''',
        [userId],
      );

      final groupActivity = await db.rawQuery(
        '''
        SELECT 
          gm.id,
          'New message in ' || sg.name AS title,
          sg.topic AS subtitle,
          'message' AS type,
          gm.joined_at AS created_at
        FROM group_members gm
        JOIN study_groups sg ON gm.group_id = sg.id
        WHERE gm.user_id = ?
        ORDER BY gm.joined_at DESC
        LIMIT 5
      ''',
        [userId],
      );

      final combined = [...skillRequests, ...groupActivity];
      combined.sort(
        (a, b) => (b['created_at'] as int).compareTo(a['created_at'] as int),
      );

      return combined.map((m) => ActivityModel.fromMap(m)).toList();
    } catch (_) {
      return [];
    }
  }
}
