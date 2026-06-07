import 'package:flutter/material.dart';
import '../../domain/entities/skill_entity.dart';

/// Data-layer model: knows how to read/write SQLite rows.
/// Also carries UI colour fields so skill_widgets.dart stays unchanged.
class SkillModel extends SkillEntity {
  final Color categoryColor;
  final Color categoryTextColor;

  const SkillModel({
    required super.id,
    required super.title,
    required super.category,
    required super.description,
    required super.ownerId,
    required super.ownerName,
    required super.ownerYear,
    required super.availability,
    required super.prerequisites,
    required super.createdAt,
    required this.categoryColor,
    required this.categoryTextColor,
  });

  // ── SQLite ──────────────────────────────────────────────────────────────

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    final cat = map['category'] as String? ?? '';
    final colors = _colorsForCategory(cat);
    return SkillModel(
      id: map['id'] as String,
      title: map['title'] as String,
      category: cat,
      description: map['description'] as String,
      ownerId: map['owner_id'] as String,
      ownerName: map['owner_name'] as String,
      ownerYear: map['owner_year'] as String,
      availability: map['availability'] as String? ?? '',
      prerequisites: map['prerequisites'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      categoryColor: colors.$1,
      categoryTextColor: colors.$2,
    );
  }

  // ── API (JSON) ──────────────────────────────────────────────────────────

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    final cat = json['category'] as String? ?? '';
    final colors = _colorsForCategory(cat);
    return SkillModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: cat,
      description: json['description'] as String,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      ownerYear: json['ownerYear'] as String? ?? '',
      availability: json['availability'] as String? ?? '',
      prerequisites: json['prerequisites'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      categoryColor: colors.$1,
      categoryTextColor: colors.$2,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'category': category,
    'description': description,
    'owner_id': ownerId,
    'owner_name': ownerName,
    'owner_year': ownerYear,
    'availability': availability,
    'prerequisites': prerequisites,
    'created_at': createdAt.millisecondsSinceEpoch,
  };

  factory SkillModel.fromEntity(SkillEntity e) {
    final colors = _colorsForCategory(e.category);
    return SkillModel(
      id: e.id,
      title: e.title,
      category: e.category,
      description: e.description,
      ownerId: e.ownerId,
      ownerName: e.ownerName,
      ownerYear: e.ownerYear,
      availability: e.availability,
      prerequisites: e.prerequisites,
      createdAt: e.createdAt,
      categoryColor: colors.$1,
      categoryTextColor: colors.$2,
    );
  }

  // ── Colour helpers (matches AppColors tag palette) ──────────────────────

  static (Color, Color) _colorsForCategory(String cat) {
    switch (cat.toLowerCase()) {
      case 'programming':
        return (const Color(0xFFD6EAF8), const Color(0xFF2E86C1));
      case 'language':
        return (const Color(0xFFF9EBEA), const Color(0xFFC0392B));
      case 'design':
        return (const Color(0xFFF5EEF8), const Color(0xFF8E44AD));
      case 'math':
        return (const Color(0xFFE8F8F5), const Color(0xFF1E8449));
      case 'science':
        return (const Color(0xFFE3F2FD), const Color(0xFF1E88E5));
      case 'music':
        return (const Color(0xFFFFF8E1), const Color(0xFFF9A825));
      default:
        return (const Color(0xFFF5EAE6), const Color(0xFFD69481));
    }
  }
}
