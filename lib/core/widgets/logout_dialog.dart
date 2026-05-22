import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_sizes.dart';
import '../theme/app_colors.dart';
import 'custom_button.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon ──────────────────────────────────────────────
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout,
                  size: 32, color: AppColors.error),
            ),

            const SizedBox(height: AppSizes.p16),

            const Text('Log Out',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: AppSizes.p8),

            const Text(
              'Are you sure you want to log out?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: AppColors.textSecondary),
            ),

            const SizedBox(height: AppSizes.p24),

            // ── Logout button ─────────────────────────────────────
            CustomButton(
              text: 'Logout',
              isDestructive: true,
              onPressed: () async {
                Navigator.pop(context); // close dialog
                // Call authProvider logout — router redirect handles navigation
                await ref.read(authProvider.notifier).logout();
              },
            ),

            const SizedBox(height: AppSizes.p8),

            // ── Cancel ────────────────────────────────────────────
            CustomButton(
              text: 'Cancel',
              isPrimary: false,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}