class UserEntity {
  final String id;
  final String fullName;
  final String email;
  final String bio;
  final String avatarPath;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.bio = '',
    this.avatarPath = '',
    required this.createdAt,
  });

  UserEntity copyWith({
    String? fullName,
    String? email,
    String? bio,
    String? avatarPath,
  }) =>
      UserEntity(
        id: id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        bio: bio ?? this.bio,
        avatarPath: avatarPath ?? this.avatarPath,
        createdAt: createdAt,
      );

  @override
  bool operator ==(Object other) =>
      other is UserEntity && other.id == id;

  @override
  int get hashCode => id.hashCode;
}