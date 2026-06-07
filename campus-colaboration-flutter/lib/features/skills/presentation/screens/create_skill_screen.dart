import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../data/models/skill_model.dart';
import '../providers/skills_provider.dart';

class CreateSkillScreen extends ConsumerStatefulWidget {
  const CreateSkillScreen({super.key});

  @override
  ConsumerState<CreateSkillScreen> createState() => _CreateSkillScreenState();
}

class _CreateSkillScreenState extends ConsumerState<CreateSkillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _availCtrl = TextEditingController();
  final _prereqCtrl = TextEditingController();
  String? _selectedCategory;
  bool _isLoading = false;

  SkillModel? _editSkill;
  bool _editMode = false;

  static const _categories = [
    'Programming',
    'Language',
    'Design',
    'Math',
    'Science',
    'Music',
    'Other',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is SkillModel && !_editMode) {
      _editSkill = extra;
      _editMode = true;
      _titleCtrl.text = extra.title;
      _descCtrl.text = extra.description;
      _availCtrl.text = extra.availability;
      _prereqCtrl.text = extra.prerequisites;
      _selectedCategory = _categories.contains(extra.category)
          ? extra.category
          : 'Programming';
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _availCtrl.dispose();
    _prereqCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    setState(() => _isLoading = true);

    String? err;

    if (_editMode && _editSkill != null) {
      final updated = _editSkill!.copyWith(
        title: _titleCtrl.text.trim(),
        category: _selectedCategory!,
        description: _descCtrl.text.trim(),
        availability: _availCtrl.text.trim(),
        prerequisites: _prereqCtrl.text.trim(),
      );
      err = await ref.read(skillsProvider.notifier).updateSkill(updated);
    } else {
      err = await ref
          .read(skillsProvider.notifier)
          .createSkill(
            title: _titleCtrl.text.trim(),
            category: _selectedCategory!,
            description: _descCtrl.text.trim(),
            availability: _availCtrl.text.trim(),
            prerequisites: _prereqCtrl.text.trim(),
          );
    }

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (err == null) {
      showSuccessSnackBar(
        context,
        _editMode ? 'Skill updated!' : 'Skill posted successfully!',
      );
      context.pop();
    } else {
      showErrorSnackBar(context, err);
    }
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
          onPressed: () => context.pop(),
        ),
        title: Text(
          _editMode ? 'Edit Skill' : 'Create Skill',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.p8),
              CustomTextField(
                label: 'Skill Title',
                hintText: 'e.g. Intro to Python Programming',
                controller: _titleCtrl,
                prefixIcon: Icons.lightbulb_outline,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter a skill title'
                    : null,
              ),
              const Text(
                'Category',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.p8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  border: Border.all(color: AppColors.divider),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    hint: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                      child: Text(
                        'Select a category',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    isExpanded: true,
                    icon: const Padding(
                      padding: EdgeInsets.only(right: AppSizes.p8),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    items: _categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.p16,
                              ),
                              child: Text(
                                c,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p16),
              CustomTextField(
                label: 'Description',
                hintText:
                    'Describe what you can teach, your experience, and how you would teach it...',
                controller: _descCtrl,
                maxLines: 5,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter a description'
                    : null,
              ),
              CustomTextField(
                label: 'Availability',
                hintText: 'e.g. Tuesdays and Thursdays: 4–6 PM',
                controller: _availCtrl,
                prefixIcon: Icons.access_time_outlined,
              ),
              CustomTextField(
                label: 'Prerequisites (optional)',
                hintText: 'e.g. Basic Java syntax, Calculus I',
                controller: _prereqCtrl,
                maxLines: 2,
              ),
              const SizedBox(height: AppSizes.p24),
              CustomButton(
                text: _editMode ? 'Save Changes' : 'Post Skill',
                onPressed: _isLoading ? null : _submit,
                isLoading: _isLoading,
              ),
              const SizedBox(height: AppSizes.p12),
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
