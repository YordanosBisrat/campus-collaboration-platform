// lib/features/groups/presentation/screens/empty_my_groups_screen.dart
// Screen: Empty My Groups — shown when the user hasn't joined any groups.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';

class EmptyMyGroupsScreen extends StatelessWidget {
  const EmptyMyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon circle
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.group_outlined,
                  size: 52,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: AppSizes.p24),

              Text(
                "You haven't joined any groups yet",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.p8),

              Text(
                'Explore and join study groups',
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.p24),

              CustomButton(
                text: 'View Groups',
                isPrimary: true,
                onPressed: () => context.go('/groups'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


