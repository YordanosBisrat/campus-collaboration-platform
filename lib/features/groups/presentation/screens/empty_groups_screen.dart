// lib/features/groups/presentation/screens/empty_groups_screen.dart
// Screen: Empty Groups — shown when no study groups exist in the system yet.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';

class EmptyGroupsScreen extends StatelessWidget {
  const EmptyGroupsScreen({super.key});

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
          'Study Groups',
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
                  color: AppColors.primary.withOpacity(0.1),
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
                'No groups available yet',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.p8),

              Text(
                'Create or join a study group to get started',
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.p24),

              CustomButton(
                text: '+ Create Group',
                isPrimary: true,
                onPressed: () => context.push('/groups/create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


