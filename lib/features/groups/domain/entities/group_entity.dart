// lib/features/groups/domain/entities/group_entity.dart
// Pure domain entity — no Flutter, no SQLite dependencies.

class GroupEntity {
  final String id;
  final String name;
  final String topic;
  final String description;
  final String creatorId;
  final int memberCount;
  final List<String> memberIds;
  final DateTime createdAt;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.topic,
    required this.description,
    required this.creatorId,
    required this.memberCount,
    this.memberIds = const [],
    required this.createdAt,
  });

  GroupEntity copyWith({
    String? name,
    String? topic,
    String? description,
    int? memberCount,
    List<String>? memberIds,
  }) =>
      GroupEntity(
        id: id,
        name: name ?? this.name,
        topic: topic ?? this.topic,
        description: description ?? this.description,
        creatorId: creatorId,
        memberCount: memberCount ?? this.memberCount,
        memberIds: memberIds ?? this.memberIds,
        createdAt: createdAt,
      );

  @override
  bool operator ==(Object other) => other is GroupEntity && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

// ── Group Member Entity ───────────────────────────────────────────────────────

enum MemberRole { admin, member }

class GroupMemberEntity {
  final String id;
  final String groupId;
  final String userId;
  final String userName;
  final String userField;
  final MemberRole role;
  final DateTime joinedAt;

  const GroupMemberEntity({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.userName,
    required this.userField,
    required this.role,
    required this.joinedAt,
  });

  bool get isAdmin => role == MemberRole.admin;
}