import '../../domain/entities/activity_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDatasource local;
  final HomeRemoteDatasource remote;

  HomeRepositoryImpl({required this.local, required this.remote});

  @override
  Future<List<ActivityEntity>> getRecentActivity(String userId) async {
    try {
      final cached = await local.getRecentActivity(userId);
      if (cached.isNotEmpty) return cached;
      return await remote.getRecentActivity(userId);
    } catch (_) {
      return await remote.getRecentActivity(userId);
    }
  }

  @override
  Future<List<ActivityEntity>> searchAll(String query) async {
    return await remote.searchAll(query);
  }
}
