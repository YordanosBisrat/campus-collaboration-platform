import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: AppSizes.p16,
        title: const Text(
          'NU',
          style: TextStyle(
            color: Color(0xFFFF9A9E),
            fontFamily: 'HoltwoodOneSC',
            fontWeight: FontWeight.w400,
            fontSize: 32,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.p16),
            child: GestureDetector(
              onTap: () {
                context.push('/profile');
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: AssetImage(
                  'assets/images/Screenshot 2026-04-17 at 4.24.32 PM.png',
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Greeting
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Hello, Nati! ',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      fontFamily: 'Inter',
                    ),
                  ),
                  TextSpan(text: '👋', style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.p4),
            const Text(
              'What would you like to do today?',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: AppSizes.p24),

            //  Skill Exchange Card
            HomeFeatureCard(
              icon: Icons.menu_book_outlined,
              iconBgColor: AppColors.primaryLight,
              iconColor: AppColors.primary,
              title: 'Skill Exchange',
              description:
                  'Learn new skills or share your expertise with peers across the campus.',
              buttonText: 'View Skills  →',
              isTextButton: false,
              onPressed: () => context.push('/skills'),
            ),
            const SizedBox(height: AppSizes.p16),

            //  Study Groups Card
            HomeFeatureCard(
              icon: Icons.group_outlined,
              iconBgColor: const Color(0xFFE0F7F4),
              iconColor: const Color(0xFF4CAF9A),
              title: 'Study Groups',
              description:
                  'Find or create study groups for your courses and collaborate effectively.',
              buttonText: 'View Groups  →',
              isTextButton: true,
              onPressed: () => context.push('/groups'),
            ),
            const SizedBox(height: AppSizes.p24),

            //  Recent Activity
            const Text(
              'Recent Activity',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: AppSizes.p16),
            const HomeActivityItem(
              icon: Icons.chat_bubble_outline_rounded,
              iconBgColor: Color(0xFFE3F0FF),
              iconColor: Color(0xFF5B9BD5),
              title: 'New message in CS 101 Group',
              subtitle: '2 hours ago',
            ),
            const SizedBox(height: AppSizes.p8),
            const HomeActivityItem(
              icon: Icons.sync_alt_rounded,
              iconBgColor: Color(0xFFE8F5E9),
              iconColor: Color(0xFF66BB6A),
              title: 'Sarah accepted your Guitar skill request',
              subtitle: 'Just now',
            ),
          ],
        ),
      ),
    );
  }
}

//  Feature Card Widget  ───────────────────────────────────────────────────────

class HomeFeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String description;
  final String buttonText;
  final bool isTextButton;
  final VoidCallback onPressed;

  const HomeFeatureCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.isTextButton,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: AppSizes.p12),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p12),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSizes.p16),
          isTextButton
              ? SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: TextButton(
                    onPressed: onPressed,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusSmall,
                        ),
                        side: const BorderSide(color: AppColors.primaryLight),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : CustomButton(
                  text: buttonText,
                  onPressed: onPressed,
                  isPrimary: true,
                ),
        ],
      ),
    );
  }
}

//  Activity Item Widget  ──────────────────────────────────────────────────────

class HomeActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;

  const HomeActivityItem({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p8,
        vertical: AppSizes.p12,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: AppSizes.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
