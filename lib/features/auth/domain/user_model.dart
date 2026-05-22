class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String bio;
  final String avatarPath;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.bio = '',
    this.avatarPath = '',
    required this.createdAt,
  });

  UserModel copyWith({
    String? fullName,
    String? email,
    String? bio,
    String? avatarPath,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt,
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

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'] as String,
    fullName: map['full_name'] as String,
    email: map['email'] as String,
    bio: map['bio'] as String? ?? '',
    avatarPath: map['avatar_path'] as String? ?? '',
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
  );
}
