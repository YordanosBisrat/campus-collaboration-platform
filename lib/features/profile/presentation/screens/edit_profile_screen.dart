// lib/features/profile/presentation/screens/edit_profile_screen.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController(text: 'Nathnael Worku');
  final _emailController = TextEditingController(
    text: 'nathnael@university.edu',
  );

  bool _isSaving = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Simulate network call
    await Future.delayed(const Duration(seconds: 1));

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

              // ── Avatar with edit pencil ──────────────────────────
              Stack(
                alignment: Alignment.bottomRight,
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
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.person,
                              size: 56,
                              color: AppColors.primary,
                            ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.p24),

              // ── Full Name ────────────────────────────────────────
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

              const SizedBox(height: AppSizes.p16),

              // ── Email Address ────────────────────────────────────
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

              const SizedBox(height: AppSizes.p24),

              // ── Save / Loading ───────────────────────────────────
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

              // ── Cancel ───────────────────────────────────────────
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

  void _pickImage() {
    // TODO: wire up with GoRouter
    // integrate image_picker:
    // final picker = ImagePicker();
    // final picked = await picker.pickImage(source: ImageSource.gallery);
    // if (picked != null) setState(() => _avatarFile = File(picked.path));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Image picker not wired yet'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
      ),
    );
  }
}
