// lib/features/groups/domain/repositories/group_repository.dart
// Abstract contract for group operations.

import '../entities/group_entity.dart';

abstract class GroupRepository {
  // ── Groups CRUD ───────────────────────────────────────────────────────────
  Future<List<GroupEntity>> getAllGroups();
  Future<List<GroupEntity>> getMyGroups(String userId);
  Future<GroupEntity?> getGroupById(String groupId);
  Future<List<GroupMemberEntity>> getGroupMembers(String groupId);

  Future<GroupEntity> createGroup({
    required String name,
    required String topic,
    required String description,
    required String creatorId,
    required String creatorName,
    required String creatorField,
  });

  Future<GroupEntity> updateGroup({
    required String groupId,
    required String name,
    required String topic,
    required String description,
  });

  Future<void> deleteGroup(String groupId);

  // ── Membership ────────────────────────────────────────────────────────────
  Future<void> joinGroup({
    required String groupId,
    required String userId,
    required String userName,
    required String userField,
  });

  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  });

  Future<bool> isMember({
    required String groupId,
    required String userId,
  });
}