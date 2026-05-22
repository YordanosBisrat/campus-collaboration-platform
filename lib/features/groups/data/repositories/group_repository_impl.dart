// lib/features/groups/data/repositories/groups_repository_impl.dart

import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/group_local_datasource.dart';
import '../datasources/group_remote_datasource.dart';
import '../models/group_model.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupLocalDatasource local;
  final GroupRemoteDatasource remote;

  const GroupRepositoryImpl({required this.local, required this.remote});

  // ── Helper: enrich GroupModel with memberIds from group_members ───────────

  Future<GroupEntity> _enrichGroup(GroupModel model) async {
    final members = await local.getGroupMembers(model.id);
    final memberIds = members.map((m) => m.userId).toList();
    return model.toEntity(memberIds: memberIds);
  }

  Future<List<GroupEntity>> _enrichGroups(List<GroupModel> models) async {
    final result = <GroupEntity>[];
    for (final m in models) {
      result.add(await _enrichGroup(m));
    }
    return result;
  }

  // ── Read ──────────────────────────────────────────────────────────────────

  @override
  Future<List<GroupEntity>> getAllGroups() async {
    final cached = await local.getAllGroups();
    if (cached.isNotEmpty) return _enrichGroups(cached);
    try {
      final remoteGroups = await remote.fetchAllGroups();
      await local.cacheGroups(remoteGroups);
      return _enrichGroups(remoteGroups);
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<GroupEntity>> getMyGroups(String userId) async {
    final cached = await local.getMyGroups(userId);
    return _enrichGroups(cached);
  }

  @override
  Future<GroupEntity?> getGroupById(String groupId) async {
    final cached = await local.getGroupById(groupId);
    if (cached != null) return _enrichGroup(cached);
    try {
      final found = await remote.fetchGroupById(groupId);
      if (found != null) {
        await local.insertGroup(found);
        return _enrichGroup(found);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<List<GroupMemberEntity>> getGroupMembers(String groupId) async {
    final cached = await local.getGroupMembers(groupId);
    if (cached.isNotEmpty) return cached.map((m) => m.toEntity()).toList();
    try {
      final remoteMembers = await remote.fetchGroupMembers(groupId);
      await local.cacheMembers(remoteMembers);
      return remoteMembers.map((m) => m.toEntity()).toList();
    } catch (_) {
      return [];
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────

  @override
  Future<GroupEntity> createGroup({
    required String name,
    required String topic,
    required String description,
    required String creatorId,
    required String creatorName,
    required String creatorField,
  }) async {
    final group = await remote.createGroup(
      name: name,
      topic: topic,
      description: description,
      creatorId: creatorId,
      creatorName: creatorName,
      creatorField: creatorField,
    );
    await local.insertGroup(group);
    final member = GroupMemberModel(
      id: local.generateMemberId(),
      groupId: group.id,
      userId: creatorId,
      userName: creatorName,
      userField: creatorField,
      role: 'admin',
      joinedAt: group.createdAt,
    );
    await local.insertMember(member);
    return group.toEntity(memberIds: [creatorId]);
  }

  // ── Update ────────────────────────────────────────────────────────────────

  @override
  Future<GroupEntity> updateGroup({
    required String groupId,
    required String name,
    required String topic,
    required String description,
  }) async {
    final updated = await remote.updateGroup(
      groupId: groupId,
      name: name,
      topic: topic,
      description: description,
    );
    await local.updateGroup(updated);
    return _enrichGroup(updated);
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  @override
  Future<void> deleteGroup(String groupId) async {
    await remote.deleteGroup(groupId);
    await local.deleteGroup(groupId);
  }

  // ── Join ──────────────────────────────────────────────────────────────────

  @override
  Future<void> joinGroup({
    required String groupId,
    required String userId,
    required String userName,
    required String userField,
  }) async {
    final member = await remote.joinGroup(
      groupId: groupId,
      userId: userId,
      userName: userName,
      userField: userField,
    );
    await local.insertMember(member);
    await local.updateMemberCount(groupId, 1);
  }

  // ── Leave ─────────────────────────────────────────────────────────────────

  @override
  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    await remote.leaveGroup(groupId: groupId, userId: userId);
    await local.deleteMember(groupId: groupId, userId: userId);
    await local.updateMemberCount(groupId, -1);
  }

  // ── Membership ────────────────────────────────────────────────────────────

  @override
  Future<bool> isMember({
    required String groupId,
    required String userId,
  }) {
    return local.isMember(groupId: groupId, userId: userId);
  }
}