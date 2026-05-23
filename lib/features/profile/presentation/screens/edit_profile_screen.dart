import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _bioController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profileState = ref.read(profileNotifierProvider);
    final name = profileState is ProfileLoaded
        ? profileState.profile.fullName
        : profileState is ProfileUpdated
        ? profileState.profile.fullName
        : '';
    final email = profileState is ProfileLoaded
        ? profileState.profile.email
        : profileState is ProfileUpdated
        ? profileState.profile.email
        : '';
    final bio = profileState is ProfileLoaded
        ? profileState.profile.bio
        : profileState is ProfileUpdated
        ? profileState.profile.bio
        : '';

    _fullNameController = TextEditingController(text: name);
    _emailController = TextEditingController(text: email);
    _bioController = TextEditingController(text: bio);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    await ref
        .read(profileNotifierProvider.notifier)
        .updateProfile(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          bio: _bioController.text.trim(),
        );

    setState(() => _isSaving = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSizes.p16),

              // ── Avatar ─────────────────────────────────────────
              Consumer(
                builder: (context, ref, _) {
                  final profileState = ref.watch(profileNotifierProvider);
                  final name = profileState is ProfileLoaded
                      ? profileState.profile.fullName
                      : profileState is ProfileUpdated
                      ? profileState.profile.fullName
                      : '?';
                  return CircleAvatar(
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
                  );
                },
              ),

              const SizedBox(height: AppSizes.p24),

              // ── Full Name ──────────────────────────────────────
              CustomTextField(
                label: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: Icons.person_outline,
                controller: _fullNameController,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Full name is required';
                  }
                  return null;
                },
              ),

              // ── Email ──────────────────────────────────────────
              CustomTextField(
                label: 'Email Address',
                hintText: 'your@university.edu',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!val.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              // ── Bio ────────────────────────────────────────────
              CustomTextField(
                label: 'Bio',
                hintText: 'Tell us about yourself...',
                prefixIcon: Icons.info_outline,
                controller: _bioController,
                maxLines: 3,
              ),

              const SizedBox(height: AppSizes.p24),

              // ── Save Button ────────────────────────────────────
              _isSaving
                  ? const SizedBox(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : CustomButton(text: 'Save Changes', onPressed: _saveChanges),

              const SizedBox(height: AppSizes.p16),

              // ── Cancel Button ──────────────────────────────────
              CustomButton(
                text: 'Cancel',
                isPrimary: false,
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: AppSizes.p24),
            ],
          ),
        ),
      ),
    );
  }
}
