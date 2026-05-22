// lib/features/groups/presentation/providers/groups_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/group_local_datasource.dart';
import '../../data/datasources/group_remote_datasource.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/group_repository_impl.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/group_repository.dart';

// ── Sealed state (matches what the screens use) ───────────────────────────────

abstract class GroupsState {}

class GroupsLoading extends GroupsState {}

class GroupsLoaded extends GroupsState {
  final List<GroupEntity> groups;
  GroupsLoaded(this.groups);
}

class GroupsError extends GroupsState {
  final String message;
  GroupsError(this.message);
}

class GroupsOperationLoading extends GroupsState {
  final List<GroupEntity> previousGroups;
  GroupsOperationLoading(this.previousGroups);
}

// ── Infrastructure providers ──────────────────────────────────────────────────

final _groupLocalDatasourceProvider = Provider<GroupLocalDatasource>((ref) {
  return GroupLocalDatasource();
});

final _groupRemoteDatasourceProvider = Provider<GroupRemoteDatasource>((ref) {
  return GroupRemoteDatasource();
});

final _groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepositoryImpl(
    local: ref.watch(_groupLocalDatasourceProvider),
    remote: ref.watch(_groupRemoteDatasourceProvider),
  );
});

// ── Main notifier — groupsProvider ────────────────────────────────────────────

class GroupsNotifier extends Notifier<GroupsState> {
  late final GroupRepository _repo;

  @override
  GroupsState build() {
    _repo = ref.read(_groupRepositoryProvider);
    Future.microtask(() => _load());
    return GroupsLoading();
  }

  List<GroupEntity> get _current {
    if (state is GroupsLoaded) return (state as GroupsLoaded).groups;
    if (state is GroupsOperationLoading) return (state as GroupsOperationLoading).previousGroups;
    return <GroupEntity>[];
  }

  Future<void> _load() async {
    state = GroupsLoading();
    try {
      final groups = await _repo.getAllGroups();
      state = GroupsLoaded(groups);
    } catch (e) {
      state = GroupsError('Failed to load groups. Please try again.');
    }
  }

  Future<void> refresh() => _load();

  // ── Create ────────────────────────────────────────────────────────────────

  Future<String?> createGroup({
    required String name,
    required String topic,
    required String description,
  }) async {
    final prev = _current;
    state = GroupsOperationLoading(prev);
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        state = GroupsLoaded(prev);
        return 'You must be logged in.';
      }
      final newGroup = await _repo.createGroup(
        name: name,
        topic: topic,
        description: description,
        creatorId: user.id,
        creatorName: user.fullName,
        creatorField: user.bio,
      );
      state = GroupsLoaded([newGroup, ...prev]);
      return null; // null = success
    } catch (e) {
      state = GroupsLoaded(prev);
      return 'Failed to create group. Please try again.';
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<String?> updateGroup({
    required String groupId,
    required String name,
    required String topic,
    required String description,
  }) async {
    final prev = _current;
    state = GroupsOperationLoading(prev);
    try {
      final updated = await _repo.updateGroup(
        groupId: groupId,
        name: name,
        topic: topic,
        description: description,
      );
      state = GroupsLoaded(
        prev.map((g) => g.id == updated.id ? updated : g).toList(),
      );
      return null;
    } catch (e) {
      state = GroupsLoaded(prev);
      return 'Failed to update group. Please try again.';
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<String?> deleteGroup(String groupId) async {
    final prev = _current;
    state = GroupsOperationLoading(prev);
    try {
      await _repo.deleteGroup(groupId);
      state = GroupsLoaded(prev.where((g) => g.id != groupId).toList());
      return null;
    } catch (e) {
      state = GroupsLoaded(prev);
      return 'Failed to delete group. Please try again.';
    }
  }

  // ── Join ──────────────────────────────────────────────────────────────────

  Future<String?> joinGroup({
    required String groupId,
  }) async {
    final prev = _current;
    state = GroupsOperationLoading(prev);
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        state = GroupsLoaded(prev);
        return 'You must be logged in.';
      }
      await _repo.joinGroup(
        groupId: groupId,
        userId: user.id,
        userName: user.fullName,
        userField: user.bio,
      );
      state = GroupsLoaded(
        prev.map((g) => g.id == groupId ? g.copyWith(memberCount: g.memberCount + 1) : g).toList(),
      );
      return null;
    } catch (e) {
      state = GroupsLoaded(prev);
      return 'Failed to join group. Please try again.';
    }
  }

  // ── Leave ─────────────────────────────────────────────────────────────────

  Future<String?> leaveGroup({
    required String groupId,
  }) async {
    final prev = _current;
    state = GroupsOperationLoading(prev);
    final user = ref.read(currentUserProvider);
    try {
      await _repo.leaveGroup(groupId: groupId, userId: user!.id);
      state = GroupsLoaded(
        prev.map((g) => g.id == groupId ? g.copyWith(memberCount: (g.memberCount - 1).clamp(0, 999999)) : g).toList(),
      );
      return null;
    } catch (e) {
      state = GroupsLoaded(prev);
      return 'Failed to leave group. Please try again.';
    }
  }
}

final groupsProvider = NotifierProvider<GroupsNotifier, GroupsState>(GroupsNotifier.new);

// ── Convenience: bool for operation-in-progress ───────────────────────────────

final isGroupOperationLoadingProvider = Provider<bool>((ref) {
  return ref.watch(groupsProvider) is GroupsOperationLoading;
});

// ── Single group by id (derived from main list) ───────────────────────────────

final singleGroupProvider = Provider.family<GroupEntity?, String>((ref, groupId) {
  final state = ref.watch(groupsProvider);
  List<GroupEntity> groups;
  if (state is GroupsLoaded) {
    groups = state.groups;
  } else if (state is GroupsOperationLoading) {
    groups = state.previousGroups;
  } else {
    groups = <GroupEntity>[];
  }
  try {
    return groups.firstWhere((g) => g.id == groupId);
  } catch (_) {
    return null;
  }
});

// ── My groups notifier ────────────────────────────────────────────────────────

abstract class MyGroupsState {}
class MyGroupsLoading extends MyGroupsState {}
class MyGroupsLoaded extends MyGroupsState {
  final List<GroupEntity> groups;
  MyGroupsLoaded(this.groups);
}
class MyGroupsError extends MyGroupsState {
  final String message;
  MyGroupsError(this.message);
}

class MyGroupsNotifier extends Notifier<MyGroupsState> {
  late final GroupRepository _repo;

  @override
  MyGroupsState build() {
    _repo = ref.read(_groupRepositoryProvider);
    final user = ref.watch(currentUserProvider);
    if (user != null) Future.microtask(() => loadMyGroups(user.id));
    return MyGroupsLoading();
  }

  Future<void> loadMyGroups(String userId) async {
    state = MyGroupsLoading();
    try {
      final groups = await _repo.getMyGroups(userId);
      state = MyGroupsLoaded(groups);
    } catch (_) {
      state = MyGroupsError('Failed to load your groups.');
    }
  }
}

final myGroupsProvider = NotifierProvider<MyGroupsNotifier, MyGroupsState>(MyGroupsNotifier.new);