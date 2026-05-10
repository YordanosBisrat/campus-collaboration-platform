// lib/features/profile/presentation/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/logout_dialog.dart'; // ✅ using shared widget
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
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

            // ── Avatar ──────────────────────────────────────────────
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: const Color(0xFFE0C8BE),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar_placeholder.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.person,
                      size: 56,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.p16),

            // ── Name & Email ─────────────────────────────────────────
            const Text(
              'Nathnael Worku',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'nathnael@university.edu',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 8),

            // ── Bio ──────────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.p24),
              child: Text(
                'Computer Science junior. Passionate about AI, open-source, and helping others learn how to code.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.p24),

            // ── Edit Profile Button ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              child: CustomButton(
                text: 'Edit Profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSizes.p24),

            // ── Account Settings Label ───────────────────────────────
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

            // ── Logout ───────────────────────────────────────────────
            _buildSettingsTile(
              icon: Icons.logout,
              iconColor: AppColors.textPrimary,
              label: 'Logout',
              onTap: () {
                // ✅ using the shared LogoutDialog from core/widgets
                showDialog(
                  context: context,
                  builder: (_) => const LogoutDialog(),
                );
              },
            ),

            // ── Delete Account ───────────────────────────────────────
            _buildSettingsTile(
              icon: Icons.delete_outline,
              iconColor: AppColors.error,
              label: 'Delete Account',
              labelColor: AppColors.error,
              onTap: _showDeleteAccountDialog,
            ),

            // ── Change Password ──────────────────────────────────────
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

            // ── Notifications Toggle ─────────────────────────────────
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
      bottomNavigationBar: _buildBottomNav(context, selectedIndex: 3),
    );
  }

  // ── Settings tile ────────────────────────────────────────────────────
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

  // ── Delete Account Dialog ────────────────────────────────────────────
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
              context.go('/');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Bottom Nav ───────────────────────────────────────────────────────
  Widget _buildBottomNav(BuildContext context, {required int selectedIndex}) {
    const labels = ['Home', 'Skills', 'Groups', 'Profile'];
    const icons = [
      Icons.home_outlined,
      Icons.lightbulb_outline,
      Icons.group_outlined,
      Icons.person_outline,
    ];
    const routes = ['/home', '/skills', '/groups', '/profile'];

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      backgroundColor: AppColors.background,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      onTap: (index) => context.go(routes[index]),
      items: List.generate(
        labels.length,
        (i) => BottomNavigationBarItem(icon: Icon(icons[i]), label: labels[i]),
      ),
    );
  }
}
