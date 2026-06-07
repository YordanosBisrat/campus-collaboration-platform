import 'package:campus_collaboration_app/features/groups/domain/entities/group_entity.dart';

class GroupModel {
  final String id;
  final String name;
  final String topic;
  final String description;
  final String creatorId;
  final int memberCount;
  final int createdAt;

  const GroupModel({
    required this.id,
    required this.name,
    required this.topic,
    required this.description,
    required this.creatorId,
    required this.memberCount,
    required this.createdAt,
  });

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

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      topic: json['topic'] as String,
      description: json['description'] as String,
      creatorId: json['creatorId'] as String,
      memberCount: json['memberCount'] as int,
      createdAt: json['createdAt'] as int,
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

class GroupMemberModel {
  final String id;
  final String groupId;
  final String userId;
  final String userName;
  final String userField;
  final String role;
  final int joinedAt;

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

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    return GroupMemberModel(
      id: json['id'] as String,
      groupId: json['group_id'] as String? ?? json['groupId'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      userName:
          json['user_name'] as String? ?? json['userName'] as String? ?? '',
      userField:
          json['user_field'] as String? ?? json['userField'] as String? ?? '',
      role: json['role'] as String,
      joinedAt: json['joined_at'] as int? ?? json['joinedAt'] as int? ?? 0,
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
