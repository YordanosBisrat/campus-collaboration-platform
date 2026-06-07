import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.bio,
    super.avatarPath,
    required super.createdAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      fullName: map['full_name'] as String,
      email: map['email'] as String,
      bio: map['bio'] as String? ?? '',
      avatarPath: map['avatar_path'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'bio': bio,
    'avatar_path': avatarPath,
    'created_at': createdAt.millisecondsSinceEpoch,
  };

  factory ProfileModel.fromEntity(ProfileEntity entity) => ProfileModel(
    id: entity.id,
    fullName: entity.fullName,
    email: entity.email,
    bio: entity.bio,
    avatarPath: entity.avatarPath,
    createdAt: entity.createdAt,
  );
}
