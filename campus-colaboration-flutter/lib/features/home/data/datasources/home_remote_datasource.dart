import '../models/activity_model.dart';

class HomeRemoteDatasource {
  Future<List<ActivityModel>> getRecentActivity(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ActivityModel(
        id: '1',
        title: 'New message in CS 101 Group',
        subtitle: '2 hours ago',
        type: 'message',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ActivityModel(
        id: '2',
        title: 'Sarah accepted your Guitar skill request',
        subtitle: 'Just now',
        type: 'skill',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
  }

  Future<List<ActivityModel>> searchAll(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }
}
