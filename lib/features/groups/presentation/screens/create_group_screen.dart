// lib/features/groups/presentation/screens/create_group_screen.dart
// Screen: Create Group — form to create a new study group.

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _topicCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _topicCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // TODO: call repository / state management
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Group "${_nameCtrl.text}" created!'),
        backgroundColor: AppColors.primary,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ── App Bar ──────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Create Group',
          style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),

      // ── Body ─────────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.p8),

              // ── Group Name ───────────────────────────────────────────────
              _FieldLabel('Group Name'),
              const SizedBox(height: AppSizes.p8),
              _GroupFormField(
                controller: _nameCtrl,
                hintText: 'Enter group name',
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Group name is required'
                    : null,
              ),

              const SizedBox(height: AppSizes.p16),

              // ── Topic ────────────────────────────────────────────────────
              _FieldLabel('Topic'),
              const SizedBox(height: AppSizes.p8),
              _GroupFormField(
                controller: _topicCtrl,
                hintText: 'e.g. Mathematics, Programming',
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Topic is required'
                    : null,
              ),

              const SizedBox(height: AppSizes.p16),

              // ── Description ──────────────────────────────────────────────
              _FieldLabel('Description'),
              const SizedBox(height: AppSizes.p8),
              _GroupFormField(
                controller: _descCtrl,
                hintText:
                    'Describe the purpose and goals of the study group...',
                maxLines: 6,
                minLines: 5,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Description is required'
                    : null,
              ),

              const SizedBox(height: AppSizes.p24),

              // ── Create button ────────────────────────────────────────────
              CustomButton(
                text: 'Create Group',
                isPrimary: true,
                onPressed: _submit,
              ),

              const SizedBox(height: AppSizes.p16),

              // ── Cancel ───────────────────────────────────────────────────
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 15, color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Field Label
// ---------------------------------------------------------------------------

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppColors.textPrimary),
    );
  }
}

// ---------------------------------------------------------------------------
// Form Field
// ---------------------------------------------------------------------------

/// Plain TextFormField styled to match the Figma Create Group form.
/// Note: CustomTextField requires a prefixIcon which the Figma design doesn't
/// have here, so we use TextFormField directly with matching styling.
class _GroupFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final int minLines;
  final String? Function(String?)? validator;

  const _GroupFormField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.minLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
      style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p16, vertical: AppSizes.p16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }
}


