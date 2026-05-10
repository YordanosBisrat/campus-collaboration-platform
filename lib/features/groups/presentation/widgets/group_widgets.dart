// lib/features/groups/presentation/widgets/group_widgets.dart
// Widgets used only within the Groups feature.
// Core-level widgets (CustomButton, CustomCard) are imported from core/widgets/.

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../models/group_model.dart';

// ---------------------------------------------------------------------------
// Topic Tag
// ---------------------------------------------------------------------------

/// Peach pill showing the group's topic (e.g. "Computer Science").
class TopicTag extends StatelessWidget {
  final String label;
  const TopicTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark_border_rounded,
              size: 13, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Member Count Chip
// ---------------------------------------------------------------------------

/// Grey rounded chip with group icon + count, used on group list cards.
class MemberCountChip extends StatelessWidget {
  final int count;
  const MemberCountChip({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.group_outlined, size: 15, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Member Avatar
// ---------------------------------------------------------------------------

/// Circular avatar with a colour-coded initial fallback.
class MemberAvatar extends StatelessWidget {
  final String name;
  final double radius;
  const MemberAvatar({super.key, required this.name, this.radius = 24});

  Color _bg(String name) {
    const palette = [
      Color(0xFFF2DDD7), Color(0xFFD7E8F2),
      Color(0xFFD7F2E2), Color(0xFFF2EDD7), Color(0xFFEDD7F2),
    ];
    return name.isEmpty ? palette[0] : palette[name.codeUnitAt(0) % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: radius,
      backgroundColor: _bg(name),
      child: Text(
        initial,
        style: TextStyle(
          fontSize: radius * 0.72,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Member Row
// ---------------------------------------------------------------------------

/// Single row in the members list: avatar | name + field | role badge.
class MemberRow extends StatelessWidget {
  final GroupMember member;
  const MemberRow({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final isAdmin = member.role == MemberRole.admin;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16, vertical: AppSizes.p16),
      child: Row(
        children: [
          MemberAvatar(name: member.name),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(member.field,
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),

          // Role indicator
          isAdmin
              ? Text('Admin',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary))
              : Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Member',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary)),
                ),
        ],
      ),
    );
  }
}


