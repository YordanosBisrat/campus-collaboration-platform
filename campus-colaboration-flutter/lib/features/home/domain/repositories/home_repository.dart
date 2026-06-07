import '../entities/activity_entity.dart';

abstract class HomeRepository {
  Future<List<ActivityEntity>> getRecentActivity(String userId);
  Future<List<ActivityEntity>> searchAll(String query);
}
