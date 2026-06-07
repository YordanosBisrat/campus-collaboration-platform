import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../data/models/skill_model.dart';
import '../../domain/entities/skill_entity.dart';
import '../providers/skills_provider.dart';
import '../widgets/skill_widgets.dart';

class MySkillsScreen extends ConsumerWidget {
  const MySkillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mySkillsProvider);

    if (state is MySkillsLoading) {
      return const Scaffold(body: ShimmerList());
    }

    if (state is MySkillsError) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Skills')),
        body: Center(
          child: Text(
            state.message,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final skills = state is MySkillsLoaded ? state.skills : <SkillEntity>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'My Skills',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: skills.isEmpty
          ? _EmptyMySkillsState()
          : ListView.builder(
              padding: const EdgeInsets.all(AppSizes.p16),
              itemCount: skills.length,
              itemBuilder: (_, i) {
                final skill = SkillModel.fromEntity(skills[i]);
                return MySkillCard(
                  skill: skill,
                  onEdit: () => context.push('/skills/create', extra: skill),
                  onDelete: () => _confirmDelete(context, ref, skill),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/skills/create'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        child: const Icon(Icons.add, size: 26),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    SkillModel skill,
  ) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Delete Skill',
      message: 'Are you sure you want to delete "${skill.title}"?',
      confirmText: 'Delete',
      isDestructive: true,
      icon: Icons.delete_outline,
    );
    if (confirmed && context.mounted) {
      final err = await ref.read(skillsProvider.notifier).deleteSkill(skill.id);
      if (context.mounted) {
        if (err == null) {
          showSuccessSnackBar(context, 'Skill deleted.');
        } else {
          showErrorSnackBar(context, err);
        }
      }
    }
  }
}

class _EmptyMySkillsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.p24),
            const Text(
              "You haven't added any skills yet",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.p8),
            const Text(
              'Start by sharing your expertise',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.p24),
            SizedBox(
              width: 160,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/skills/create'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                label: const Text(
                  'Add Skill',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
