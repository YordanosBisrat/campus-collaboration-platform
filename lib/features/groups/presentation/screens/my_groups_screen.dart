// lib/features/groups/presentation/screens/my_groups_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/group_entity.dart';
import '../providers/groups_provider.dart';

class MyGroupsScreen extends ConsumerWidget {
  const MyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myGroupsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Groups',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: switch (state) {
        MyGroupsLoading() => const Center(
            child:
                CircularProgressIndicator(color: AppColors.primary),
          ),
        MyGroupsError(:final message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.p32),
              child: Text(message,
                  style:
                      const TextStyle(color: AppColors.textSecondary)),
            ),
          ),
        MyGroupsLoaded(:final groups) => groups.isEmpty
            ? _EmptyMyGroupsBody()
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.p16, AppSizes.p8, AppSizes.p16, AppSizes.p24),
                itemCount: groups.length,
                itemBuilder: (_, i) =>
                    _MyGroupCard(group: groups[i]),
              ),
        _ => _EmptyMyGroupsBody(),
      },
    );
  }
}

// ── My Group Card ─────────────────────────────────────────────────────────────

class _MyGroupCard extends StatelessWidget {
  final GroupEntity group;
  const _MyGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: AppSizes.p16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.p4),
            Row(
              children: [
                const Icon(Icons.group_outlined,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: AppSizes.p4),
                Text(
                  '${group.memberCount} Members',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p8),
            Divider(color: Colors.grey.shade200, thickness: 1),
            const SizedBox(height: AppSizes.p8),
            CustomButton(
              text: 'View Details',
              isPrimary: true,
              onPressed: () =>
                  context.push('/groups/detail', extra: group),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyMyGroupsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.group_outlined,
                  size: 52, color: AppColors.primary),
            ),
            const SizedBox(height: AppSizes.p24),
            const Text(
              "You haven't joined any groups yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.p8),
            const Text(
              'Explore and join study groups',
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.p24),
            CustomButton(
              text: 'View Groups',
              isPrimary: true,
              onPressed: () => context.go('/groups'),
            ),
          ],
        ),
      ),
    );
  }
}