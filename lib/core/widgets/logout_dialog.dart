import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_sizes.dart';
import '../theme/app_colors.dart';
import 'custom_button.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.logout, size: 40, color: AppColors.primary),

            const SizedBox(height: AppSizes.p16),

            const Text(
              "Log Out",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: AppSizes.p8),

            const Text(
              "Are you sure you want to log out?",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSizes.p16),

            CustomButton(
              text: "Logout",
              onPressed: () {
                context.go('/'); // go back to login
              },
            ),

            const SizedBox(height: AppSizes.p8),

            CustomButton(
              text: "Cancel",
              isPrimary: false,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
