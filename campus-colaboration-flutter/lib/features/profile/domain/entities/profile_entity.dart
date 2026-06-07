class ProfileEntity {
  final String id;
  final String fullName;
  final String email;
  final String bio;
  final String avatarPath;
  final DateTime createdAt;

  const ProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.bio = '',
    this.avatarPath = '',
    required this.createdAt,
  });

  ProfileEntity copyWith({
    String? fullName,
    String? email,
    String? bio,
    String? avatarPath,
  }) => ProfileEntity(
    id: id,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    bio: bio ?? this.bio,
    avatarPath: avatarPath ?? this.avatarPath,
    createdAt: createdAt,
  );
}
