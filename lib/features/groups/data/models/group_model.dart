// lib/features/groups/models/group_model.dart
// IMPORTANT: This file must stay at this path.
// app_router.dart imports from '../../features/groups/models/group_model.dart'
//
// Matches the exact SQLite schema from app_database.dart:
//   study_groups: id, name, topic, description, creator_id, member_count, created_at (INTEGER)
//   group_members: id, group_id, user_id, user_name, user_field, role, joined_at (INTEGER)

import 'package:campus_collaboration_app/features/groups/domain/entities/group_entity.dart';

// ── Group Model ───────────────────────────────────────────────────────────────

class GroupModel {
  final String id;
  final String name;
  final String topic;
  final String description;
  final String creatorId;
  final int memberCount;
  final int createdAt; // Unix timestamp (milliseconds) — matches INTEGER column

  const GroupModel({
    required this.id,
    required this.name,
    required this.topic,
    required this.description,
    required this.creatorId,
    required this.memberCount,
    required this.createdAt,
  });

  // ── SQLite ────────────────────────────────────────────────────────────────

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] as String,
      name: map['name'] as String,
      topic: map['topic'] as String,
      description: map['description'] as String,
      creatorId: map['creator_id'] as String,
      memberCount: map['member_count'] as int,
      createdAt: map['created_at'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'topic': topic,
      'description': description,
      'creator_id': creatorId,
      'member_count': memberCount,
      'created_at': createdAt,
    };
  }

  // ── Entity conversion ─────────────────────────────────────────────────────

  GroupEntity toEntity({List<String> memberIds = const []}) {
    return GroupEntity(
      id: id,
      name: name,
      topic: topic,
      description: description,
      creatorId: creatorId,
      memberCount: memberCount,
      memberIds: memberIds,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    );
  }

  factory GroupModel.fromEntity(GroupEntity entity) {
    return GroupModel(
      id: entity.id,
      name: entity.name,
      topic: entity.topic,
      description: entity.description,
      creatorId: entity.creatorId,
      memberCount: entity.memberCount,
      createdAt: entity.createdAt.millisecondsSinceEpoch,
    );
  }

  GroupModel copyWith({
    String? name,
    String? topic,
    String? description,
    int? memberCount,
  }) {
    return GroupModel(
      id: id,
      name: name ?? this.name,
      topic: topic ?? this.topic,
      description: description ?? this.description,
      creatorId: creatorId,
      memberCount: memberCount ?? this.memberCount,
      createdAt: createdAt,
    );
  }
}

// ── Group Member Model ────────────────────────────────────────────────────────

class GroupMemberModel {
  final String id;
  final String groupId;
  final String userId;
  final String userName;
  final String userField;
  final String role; // 'admin' | 'member'
  final int joinedAt; // Unix timestamp

  const GroupMemberModel({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.userName,
    required this.userField,
    required this.role,
    required this.joinedAt,
  });

  factory GroupMemberModel.fromMap(Map<String, dynamic> map) {
    return GroupMemberModel(
      id: map['id'] as String,
      groupId: map['group_id'] as String,
      userId: map['user_id'] as String,
      userName: map['user_name'] as String,
      userField: map['user_field'] as String,
      role: map['role'] as String,
      joinedAt: map['joined_at'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'group_id': groupId,
      'user_id': userId,
      'user_name': userName,
      'user_field': userField,
      'role': role,
      'joined_at': joinedAt,
    };
  }

  GroupMemberEntity toEntity() {
    return GroupMemberEntity(
      id: id,
      groupId: groupId,
      userId: userId,
      userName: userName,
      userField: userField,
      role: role == 'admin' ? MemberRole.admin : MemberRole.member,
      joinedAt: DateTime.fromMillisecondsSinceEpoch(joinedAt),
    );
  }
}