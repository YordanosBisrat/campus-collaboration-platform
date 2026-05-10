import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;

  const CategoryChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colors.$2,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, Color) _getColors(String label) {
    switch (label.toLowerCase()) {
      case 'skill':
        return (AppColors.tagProgramming, AppColors.tagProgrammingText);
      case 'group':
        return (AppColors.tagDesign, AppColors.tagDesignText);
      case 'programming':
        return (AppColors.tagProgramming, AppColors.tagProgrammingText);
      case 'language':
        return (AppColors.tagLanguage, AppColors.tagLanguageText);
      case 'design':
        return (AppColors.tagDesign, AppColors.tagDesignText);
      case 'math':
        return (AppColors.tagMath, AppColors.tagMathText);
      default:
        return (AppColors.primaryLight, AppColors.primary);
    }
  }
}