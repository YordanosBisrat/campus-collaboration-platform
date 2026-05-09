import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
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
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: const Color(0xFFE0C8BE),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/avatar_placeholder.png',
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          size: 56,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
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

            // ── Settings List ────────────────────────────────────────
            _buildSettingsTile(
              icon: Icons.logout,
              iconColor: AppColors.textPrimary,
              label: 'Logout',
              onTap: _showLogoutDialog,
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
              onTap: () {
                Navigator.pushNamed(context, '/change-password');
              },
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
                    onChanged: (val) {
                      setState(() => _notificationsEnabled = val);
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.p24),
          ],
        ),
      ),

      // ── Bottom Nav Bar ───────────────────────────────────────────────
      bottomNavigationBar: _buildBottomNav(selectedIndex: 3),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────

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
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to log out?'),
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
              // TODO: trigger logout logic / GoRouter redirect to login
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
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
              // TODO: trigger delete account logic
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav({required int selectedIndex}) {
    const items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.lightbulb_outline, 'label': 'Skills'},
      {'icon': Icons.group_outlined, 'label': 'Groups'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
    ];

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      backgroundColor: AppColors.background,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      onTap: (index) {
        // TODO: wire up with GoRouter
        // e.g. context.go(routes[index])
      },
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item['icon'] as IconData),
              label: item['label'] as String,
            ),
          )
          .toList(),
    );
  }
}
