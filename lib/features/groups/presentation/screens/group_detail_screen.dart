

// lib/features/groups/presentation/screens/group_detail_screen.dart
// Screen: Group Details — full info view for a single study group.

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../models/group_model.dart';
import '../widgets/group_widgets.dart';

class GroupDetailScreen extends StatelessWidget {
  final GroupModel group;
  const GroupDetailScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    // Use group's own member list, fall back to demo data if empty.
    final members = group.members.isNotEmpty
        ? group.members
        : GroupMockData.advancedML.members;

    return Scaffold(
      backgroundColor: AppColors.background,

      // ── App Bar ──────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Group Details',
          style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.ios_share_outlined,
                size: 22, color: AppColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share link copied!')),
              );
            },
          ),
        ],
      ),

      // ── Sticky Join Button ────────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSizes.p16, AppSizes.p8, AppSizes.p16, AppSizes.p16),
          child: CustomButton(
            text: 'Join Group',
            isPrimary: true,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Requested to join "${group.name}"'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
        ),
      ),

      // ── Body ─────────────────────────────────────────────────────────────
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.p16),
        children: [
          // Info card
          _GroupInfoCard(group: group),
          const SizedBox(height: AppSizes.p24),

          // Members section header
          _MembersSectionHeader(count: group.memberCount),
          const SizedBox(height: AppSizes.p16),

          // Members list card
          _MembersCard(members: members),
          const SizedBox(height: AppSizes.p24),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Group Info Card
// ---------------------------------------------------------------------------

class _GroupInfoCard extends StatelessWidget {
  final GroupModel group;
  const _GroupInfoCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group name
            Text(
              group.name,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.25),
            ),

            const SizedBox(height: AppSizes.p16),
            TopicTag(label: group.topic),

            const SizedBox(height: AppSizes.p8),

            // Member count row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.group_outlined,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    '${group.memberCount} Members',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.p16),

            // Description
            Text(
              group.description,
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.55),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Members Section Header
// ---------------------------------------------------------------------------

class _MembersSectionHeader extends StatelessWidget {
  final int count;
  const _MembersSectionHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Members',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
        const SizedBox(width: AppSizes.p8),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Members List Card
// ---------------------------------------------------------------------------

class _MembersCard extends StatelessWidget {
  final List<GroupMember> members;
  const _MembersCard({required this.members});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: members.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          thickness: 1,
          indent: 68,
          color: Colors.grey.shade200,
        ),
        itemBuilder: (_, index) => MemberRow(member: members[index]),
      ),
    );
  }
}





