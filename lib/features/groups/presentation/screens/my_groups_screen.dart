// lib/features/groups/presentation/screens/my_groups_screen.dart
// Screen: My Groups — lists groups the current user has joined.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../models/group_model.dart';
import '../widgets/group_widgets.dart';

class MyGroupsScreen extends StatelessWidget {
  const MyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = GroupMockData.myGroups;

    // If user has no joined groups, show empty state.
    if (groups.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushReplacement('/groups/my-groups/empty');
      });
      return const Scaffold();
    }

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
          'My Groups',
          style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),

      // ── Body ─────────────────────────────────────────────────────────────
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
            AppSizes.p16, AppSizes.p8, AppSizes.p16, AppSizes.p24),
        itemCount: groups.length,
        itemBuilder: (context, index) =>
            _MyGroupCard(group: groups[index]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// My Group Card
// ---------------------------------------------------------------------------

/// Card with a filled primary "View Details" button — distinct from GroupListCard.
class _MyGroupCard extends StatelessWidget {
  final GroupModel group;
  const _MyGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: AppSizes.p16),
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
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary),
            ),

            const SizedBox(height: AppSizes.p4),

            // Member count
            Row(
              children: [
                Icon(Icons.group_outlined,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: AppSizes.p4),
                Text(
                  '${group.memberCount} Members',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.p8),
            Divider(color: Colors.grey.shade200, thickness: 1),
            const SizedBox(height: AppSizes.p8),

            // Filled view details button
            CustomButton(
              text: 'View Details',
              isPrimary: true,
              onPressed: () =>
                  context.push('/groups/detail', extra: group),
            ),
          ],
        ),
      ),
    );
  }
}

