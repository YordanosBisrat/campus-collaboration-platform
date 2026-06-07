import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/group_local_datasource.dart';
import '../datasources/group_remote_datasource.dart';
import '../models/group_model.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupLocalDatasource local;
  final GroupRemoteDatasource remote;

  const GroupRepositoryImpl({required this.local, required this.remote});

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

  @override
  Future<List<GroupEntity>> getAllGroups() async {
    try {
      final remoteGroups = await remote.fetchAllGroups();
      await local.cacheGroups(remoteGroups);
      return _enrichGroups(remoteGroups);
    } catch (_) {
      final cached = await local.getAllGroups();
      return _enrichGroups(cached);
    }
  }

  @override
  Future<List<GroupEntity>> getMyGroups(String userId) async {
    try {
      final remoteGroups = await remote.fetchAllGroups();
      await local.cacheGroups(remoteGroups);

      final groupMembers = <GroupMemberModel>[];
      for (final group in remoteGroups) {
        final members = await remote.fetchGroupMembers(group.id);
        groupMembers.addAll(members);
      }
      if (groupMembers.isNotEmpty) {
        await local.cacheMembers(groupMembers);
      }

      final myGroups = remoteGroups.where((group) {
        if (group.creatorId == userId) return true;
        return groupMembers.any(
          (member) => member.groupId == group.id && member.userId == userId,
        );
      }).toList();

      return _enrichGroups(myGroups);
    } catch (_) {
      final cached = await local.getMyGroups(userId);
      return _enrichGroups(cached);
    }
  }

  @override
  Future<GroupEntity?> getGroupById(String groupId) async {
    try {
      final found = await remote.fetchGroupById(groupId);
      if (found != null) {
        await local.insertGroup(found);
        return _enrichGroup(found);
      }
    } catch (_) {}
    final cached = await local.getGroupById(groupId);
    if (cached != null) return _enrichGroup(cached);
    return null;
  }

  @override
  Future<List<GroupMemberEntity>> getGroupMembers(String groupId) async {
    try {
      final remoteMembers = await remote.fetchGroupMembers(groupId);
      await local.cacheMembers(remoteMembers);
      return remoteMembers.map((m) => m.toEntity()).toList();
    } catch (_) {
      final cached = await local.getGroupMembers(groupId);
      return cached.map((m) => m.toEntity()).toList();
    }
  }

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

  @override
  Future<void> deleteGroup(String groupId) async {
    await remote.deleteGroup(groupId);
    await local.deleteGroup(groupId);
  }

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

  @override
  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    await remote.leaveGroup(groupId: groupId, userId: userId);
    await local.deleteMember(groupId: groupId, userId: userId);
    await local.updateMemberCount(groupId, -1);
  }

  @override
  Future<bool> isMember({required String groupId, required String userId}) {
    return local.isMember(groupId: groupId, userId: userId);
  }
}
