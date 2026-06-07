import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_sizes.dart';
import 'custom_button.dart';

// ── Confirm Dialog ────────────────────────────────────────────────────────────

/// Generic two-button confirm dialog.
/// Returns true if confirmed, false if cancelled.
Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool isDestructive = false,
  IconData? icon,
  Color? iconColor,
  Color? iconBgColor,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ConfirmDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: isDestructive,
      icon: icon,
      iconColor: iconColor,
      iconBgColor: iconBgColor,
    ),
  );
  return result ?? false;
}

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBgColor;

  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.isDestructive,
    this.icon,
    this.iconColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color:
                      iconBgColor ??
                      (isDestructive
                          ? AppColors.errorLight
                          : AppColors.primaryLight),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color:
                      iconColor ??
                      (isDestructive ? AppColors.error : AppColors.primary),
                ),
              ),
              const SizedBox(height: AppSizes.p16),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.p8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.p24),
            CustomButton(
              text: confirmText,
              isDestructive: isDestructive,
              isPrimary: !isDestructive,
              onPressed: () => Navigator.pop(context, true),
            ),
            const SizedBox(height: AppSizes.p8),
            CustomButton(
              text: cancelText,
              isPrimary: false,
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info / Success Dialog ─────────────────────────────────────────────────────

/// Simple single-button info/success dialog.
Future<void> showInfoDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'OK',
  IconData icon = Icons.check_circle_outline_rounded,
  Color iconColor = AppColors.success,
  Color iconBgColor = AppColors.successLight,
}) async {
  await showDialog<void>(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: iconColor),
            ),
            const SizedBox(height: AppSizes.p16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.p8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.p24),
            CustomButton(
              text: buttonText,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    ),
  );
}

// ── Logout Dialog ─────────────────────────────────────────────────────────────

/// Shows the logout confirmation dialog.
/// Call [onConfirm] on Yes.
Future<void> showLogoutDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) async {
  final confirmed = await showConfirmDialog(
    context: context,
    title: 'Log Out',
    message: 'Are you sure you want to log out?',
    confirmText: 'Logout',
    cancelText: 'Cancel',
    isDestructive: true,
    icon: Icons.logout,
  );
  if (confirmed) onConfirm();
}

// ── SnackBar helpers ──────────────────────────────────────────────────────────

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 18),
          const SizedBox(width: AppSizes.p8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: AppColors.success,
    ),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 18),
          const SizedBox(width: AppSizes.p8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: AppColors.error,
    ),
  );
}

void showInfoSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: AppColors.textPrimary),
  );
}
