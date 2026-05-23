class SkillEntity {
  final String id;
  final String title;
  final String category;
  final String description;
  final String ownerId;
  final String ownerName;
  final String ownerYear;
  final String availability;
  final String prerequisites;
  final DateTime createdAt;

  const SkillEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.ownerId,
    required this.ownerName,
    required this.ownerYear,
    required this.availability,
    required this.prerequisites,
    required this.createdAt,
  });

  SkillEntity copyWith({
    String? title,
    String? category,
    String? description,
    String? availability,
    String? prerequisites,
  }) {
    return SkillEntity(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      ownerId: ownerId,
      ownerName: ownerName,
      ownerYear: ownerYear,
      availability: availability ?? this.availability,
      prerequisites: prerequisites ?? this.prerequisites,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) => other is SkillEntity && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
