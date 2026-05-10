// lib/features/skills/models/skill_model.dart

import 'package:flutter/material.dart';

class SkillModel {
  final String id;
  final String title;
  final String category;
  final Color categoryColor;
  final Color categoryTextColor;
  final String description;
  final String ownerName;
  final String ownerYear;
  final String? availability;
  final String? prerequisites;

  const SkillModel({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.categoryTextColor,
    required this.description,
    required this.ownerName,
    required this.ownerYear,
    this.availability,
    this.prerequisites,
  });
}
