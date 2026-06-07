import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A small colored label chip for skill/group categories.
class CategoryChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  const CategoryChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.$1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? colors.$2,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, Color) _resolveColors(String label) {
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
      case 'science':
        return (AppColors.infoLight, AppColors.info);
      default:
        return (AppColors.primaryLight, AppColors.primary);
    }
  }
}
