import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../data/datasources/home_local_datasource.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/repositories/home_repository.dart';

// ── Datasource Providers ──────────────────────────────────
final homeLocalDatasourceProvider =
    Provider<HomeLocalDatasource>((_) => HomeLocalDatasource());

final homeRemoteDatasourceProvider =
    Provider<HomeRemoteDatasource>((_) => HomeRemoteDatasource());

// ── Repository Provider ───────────────────────────────────
final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepositoryImpl(
    local: ref.watch(homeLocalDatasourceProvider),
    remote: ref.watch(homeRemoteDatasourceProvider),
  ),
);

// ── Home State ────────────────────────────────────────────
sealed class HomeState {}
final class HomeInitial extends HomeState {}
final class HomeLoading extends HomeState {}
final class HomeLoaded extends HomeState {
  final List<ActivityEntity> activities;
  HomeLoaded(this.activities);
}
final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

// ── Search State ──────────────────────────────────────────
sealed class SearchState {}
final class SearchInitial extends SearchState {}
final class SearchLoading extends SearchState {}
final class SearchLoaded extends SearchState {
  final List<ActivityEntity> results;
  SearchLoaded(this.results);
}
final class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

// ── Home Notifier ─────────────────────────────────────────
class HomeNotifier extends Notifier<HomeState> {
  late final HomeRepository _repository;

  @override
  HomeState build() {
    _repository = ref.watch(homeRepositoryProvider);
    loadActivity();
    return HomeInitial();
  }

  Future<void> loadActivity() async {
    state = HomeLoading();
    try {
      final authState = ref.read(authProvider);
      if (authState is! AuthAuthenticated) {
        state = HomeError('Not authenticated');
        return;
      }
      final activities =
          await _repository.getRecentActivity(authState.user.id);
      state = HomeLoaded(activities);
    } catch (e) {
      state = HomeError(e.toString());
    }
  }
}

// ── Search Notifier ───────────────────────────────────────
class SearchNotifier extends Notifier<SearchState> {
  late final HomeRepository _repository;

  @override
  SearchState build() {
    _repository = ref.watch(homeRepositoryProvider);
    return SearchInitial();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = SearchInitial();
      return;
    }
    state = SearchLoading();
    try {
      final results = await _repository.searchAll(query);
      state = SearchLoaded(results);
    } catch (e) {
      state = SearchError(e.toString());
    }
  }

  void clear() => state = SearchInitial();
}

// ── Providers ─────────────────────────────────────────────
final homeNotifierProvider =
    NotifierProvider<HomeNotifier, HomeState>(HomeNotifier.new);

final searchNotifierProvider =
    NotifierProvider<SearchNotifier, SearchState>(SearchNotifier.new);
