import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/skill_model.dart';
import '../providers/skills_provider.dart';

class SkillDetailScreen extends ConsumerWidget {
  final SkillModel skill;

  const SkillDetailScreen({super.key, required this.skill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final isOwner = currentUser?.id == skill.ownerId;
    final isLoading = ref.watch(isSkillOperationLoadingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Skill Details',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          if (isOwner)
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  context.push('/skills/create', extra: skill);
                } else if (value == 'delete') {
                  final confirmed = await showConfirmDialog(
                    context: context,
                    title: 'Delete Skill',
                    message:
                        'Are you sure you want to delete "${skill.title}"? This cannot be undone.',
                    confirmText: 'Delete',
                    isDestructive: true,
                    icon: Icons.delete_outline,
                  );
                  if (confirmed && context.mounted) {
                    final err = await ref
                        .read(skillsProvider.notifier)
                        .deleteSkill(skill.id);
                    if (context.mounted) {
                      if (err == null) {
                        showSuccessSnackBar(context, 'Skill deleted.');
                        context.pop();
                      } else {
                        showErrorSnackBar(context, err);
                      }
                    }
                  }
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Delete',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.p8),

            // Title + category chip
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    skill.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.p8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: skill.categoryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill.category,
                    style: TextStyle(
                      color: skill.categoryTextColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.p16),

            // Owner card
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.person, size: 20, color: AppColors.primary),
                ),
                const SizedBox(width: AppSizes.p12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill.ownerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        skill.ownerYear,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.p24),
            const Divider(color: AppColors.divider),
            const SizedBox(height: AppSizes.p16),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.p8),
            Text(
              skill.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),

            if (skill.availability.isNotEmpty) ...[
              const SizedBox(height: AppSizes.p24),
              const Text(
                'Availability:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.p4),
              Text(
                skill.availability,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],

            if (skill.prerequisites.isNotEmpty) ...[
              const SizedBox(height: AppSizes.p16),
              const Text(
                'Prerequisites:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.p4),
              Text(
                skill.prerequisites,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],

            const SizedBox(height: AppSizes.p32),

            // Request / Edit button
            if (!isOwner)
              CustomButton(
                text: 'Request Skill',
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () async {
                        final err = await ref
                            .read(skillsProvider.notifier)
                            .requestSkill(
                              skillId: skill.id,
                              skillTitle: skill.title,
                            );
                        if (context.mounted) {
                          if (err == null) {
                            context.push('/skills/success-confirmation');
                          } else {
                            showErrorSnackBar(context, err);
                          }
                        }
                      },
              ),

            if (isOwner)
              CustomButton(
                text: 'Edit Skill',
                isPrimary: false,
                onPressed: () => context.push('/skills/create', extra: skill),
              ),

            const SizedBox(height: AppSizes.p16),
          ],
        ),
      ),
    );
  }
}
