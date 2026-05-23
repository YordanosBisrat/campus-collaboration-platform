import '../../domain/entities/activity_entity.dart';

class ActivityModel extends ActivityEntity {
  const ActivityModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.type,
    required super.createdAt,
  });

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String? ?? '',
      type: map['type'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'type': type,
        'created_at': createdAt.toIso8601String(),
      };

  factory ActivityModel.fromEntity(ActivityEntity entity) => ActivityModel(
        id: entity.id,
        title: entity.title,
        subtitle: entity.subtitle,
        type: entity.type,
        createdAt: entity.createdAt,
      );
}
