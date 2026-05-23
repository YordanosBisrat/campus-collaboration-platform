import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/logout_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileNotifierProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    final name = switch (profileState) {
      ProfileLoaded(:final profile) => profile.fullName,
      ProfileUpdated(:final profile) => profile.fullName,
      _ => 'Loading...',
    };

    final email = switch (profileState) {
      ProfileLoaded(:final profile) => profile.email,
      ProfileUpdated(:final profile) => profile.email,
      _ => '',
    };

    final bio = switch (profileState) {
      ProfileLoaded(:final profile) => profile.bio,
      ProfileUpdated(:final profile) => profile.bio,
      _ => '',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSizes.p16),

            // ── Avatar ─────────────────────────────────────────
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.p16),

            // ── Name & Email ───────────────────────────────────
            profileState is ProfileLoading
                ? const CircularProgressIndicator(color: AppColors.primary)
                : Column(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      if (bio.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.p24,
                          ),
                          child: Text(
                            bio,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

            const SizedBox(height: AppSizes.p24),

            // ── Edit Profile Button ────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              child: CustomButton(
                text: 'Edit Profile',
                onPressed: () => context.push('/edit-profile'),
              ),
            ),

            const SizedBox(height: AppSizes.p24),

            // ── Account Settings ───────────────────────────────
            const Padding(
              padding: EdgeInsets.only(left: AppSizes.p16, bottom: AppSizes.p8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account Settings',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            _buildSettingsTile(
              icon: Icons.logout,
              iconColor: AppColors.textPrimary,
              label: 'Logout',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const LogoutDialog(),
                );
              },
            ),

            _buildSettingsTile(
              icon: Icons.delete_outline,
              iconColor: AppColors.error,
              label: 'Delete Account',
              labelColor: AppColors.error,
              onTap: _showDeleteAccountDialog,
            ),

            _buildSettingsTile(
              icon: Icons.lock_outline,
              iconColor: AppColors.textPrimary,
              label: 'Change Password',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
              onTap: () => context.push('/change-password'),
            ),

            // ── Notifications Toggle ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p16,
                vertical: 4,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                  const SizedBox(width: AppSizes.p16),
                  const Expanded(
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: (val) =>
                        setState(() => _notificationsEnabled = val),
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.p24),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = AppColors.textPrimary,
    Color labelColor = AppColors.textPrimary,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: 4,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: AppSizes.p16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: labelColor, fontSize: 15),
              ),
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        title: const Text(
          'Delete Account',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error),
        ),
        content: const Text(
          'This action is permanent and cannot be undone. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
              context.go('/');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
