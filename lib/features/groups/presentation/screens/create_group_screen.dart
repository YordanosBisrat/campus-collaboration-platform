// lib/features/groups/presentation/screens/create_group_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../providers/groups_provider.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() =>
      _CreateGroupScreenState();
}

class _CreateGroupScreenState
    extends ConsumerState<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _topicCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _topicCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    final err = await ref.read(groupsProvider.notifier).createGroup(
          name: _nameCtrl.text.trim(),
          topic: _topicCtrl.text.trim(),
          description: _descCtrl.text.trim(),
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (err == null) {
      showSuccessSnackBar(context, 'Group created successfully!');
      context.pop();
    } else {
      showErrorSnackBar(context, err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ── App Bar ──────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Create Group',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.p8),

              // ── Group Name ─────────────────────────────────────────
              CustomTextField(
                label: 'Group Name',
                hintText: 'Enter group name',
                controller: _nameCtrl,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Group name is required'
                    : null,
              ),

              // ── Topic ──────────────────────────────────────────────
              CustomTextField(
                label: 'Topic',
                hintText: 'e.g. Mathematics, Programming',
                controller: _topicCtrl,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Topic is required'
                    : null,
              ),

              // ── Description ────────────────────────────────────────
              CustomTextField(
                label: 'Description',
                hintText:
                    'Describe the purpose and goals of the study group...',
                controller: _descCtrl,
                maxLines: 5,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Description is required'
                    : null,
              ),

              const SizedBox(height: AppSizes.p24),

              // ── Create button ──────────────────────────────────────
              CustomButton(
                text: 'Create Group',
                isPrimary: true,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _submit,
              ),

              const SizedBox(height: AppSizes.p12),

              // ── Cancel ─────────────────────────────────────────────
              CustomButton(
                text: 'Cancel',
                isPrimary: false,
                onPressed: () => context.pop(),
              ),

              const SizedBox(height: AppSizes.p24),
            ],
          ),
        ),
      ),
    );
  }
}