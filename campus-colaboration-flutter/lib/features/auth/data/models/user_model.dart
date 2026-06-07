import '../../domain/entities/user_entity.dart';

/// Data model — knows how to serialize/deserialize from SQLite maps.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.bio,
    super.avatarPath,
    required super.createdAt,
  });

  /// Convert to SQLite map (without password — stored separately)
  Map<String, dynamic> toMap() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'bio': bio,
        'avatar_path': avatarPath,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  /// Create from SQLite row
  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] as String,
        fullName: map['full_name'] as String,
        email: map['email'] as String,
        bio: map['bio'] as String? ?? '',
        avatarPath: map['avatar_path'] as String? ?? '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            map['created_at'] as int),
      );

  /// Convert domain entity → model
  factory UserModel.fromEntity(UserEntity e) => UserModel(
        id: e.id,
        fullName: e.fullName,
        email: e.email,
        bio: e.bio,
        avatarPath: e.avatarPath,
        createdAt: e.createdAt,
      );
}