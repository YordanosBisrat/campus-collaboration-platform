import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_sizes.dart';
import 'custom_button.dart';

class ErrorState extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onRetry;

  const ErrorState({
    super.key,
    this.title = 'Failed to load data',
    this.subtitle = "We couldn't load the data. Please check your connection and try again.",
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, color: AppColors.error, size: 56),
            const SizedBox(height: AppSizes.p24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.p8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.p24),
            SizedBox(
              width: 140,
              child: CustomButton(
                text: '↻  Retry',
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}