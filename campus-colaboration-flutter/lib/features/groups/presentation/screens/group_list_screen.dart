// lib/features/groups/presentation/screens/group_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/group_entity.dart';
import '../providers/groups_provider.dart';
import '../widgets/group_widgets.dart';

class GroupListScreen extends ConsumerStatefulWidget {
  const GroupListScreen({super.key});

  @override
  ConsumerState<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends ConsumerState<GroupListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(groupsProvider);

    List<GroupEntity> groups = [];
    bool loading = false;
    String? error;

    if (state is GroupsLoading) loading = true;
    if (state is GroupsLoaded) groups = state.groups;
    if (state is GroupsOperationLoading) groups = state.previousGroups;
    if (state is GroupsError) error = state.message;

    final q = _searchController.text.toLowerCase();
    final displayed = q.isEmpty
        ? groups
        : groups
              .where(
                (g) =>
                    g.name.toLowerCase().contains(q) ||
                    g.topic.toLowerCase().contains(q),
              )
              .toList();

    return Scaffold(
      backgroundColor: AppColors.background,

      // ── App Bar ────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Study Groups',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        // FIX: added My Groups action button
        actions: [
          IconButton(
            icon: const Icon(
              Icons.group_outlined,
              color: AppColors.textPrimary,
            ),
            tooltip: 'My Groups',
            onPressed: () => context.push('/groups/my-groups'),
          ),
        ],
      ),

      // ── NO bottomNavigationBar — MainShell handles it ──────────────────
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(
              AppSizes.p16,
              AppSizes.p8,
              AppSizes.p16,
              AppSizes.p16,
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search study groups...',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // Group list
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : error != null
                ? Center(
                    child: Text(
                      error,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  )
                : displayed.isEmpty
                ? const Center(
                    child: Text(
                      'No groups found',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () =>
                        ref.read(groupsProvider.notifier).refresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.p16,
                        AppSizes.p8,
                        AppSizes.p16,
                        80,
                      ),
                      itemCount: displayed.length,
                      itemBuilder: (context, index) =>
                          _GroupListCard(group: displayed[index]),
                    ),
                  ),
          ),
        ],
      ),

      // FIX: Create Group FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/groups/create'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        child: const Icon(Icons.add, size: 26),
      ),
    );
  }
}

// ── Group List Card ───────────────────────────────────────────────────────────

class _GroupListCard extends StatelessWidget {
  final GroupEntity group;
  const _GroupListCard({required this.group});

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.p8),
                MemberCountChip(count: group.memberCount),
              ],
            ),
            const SizedBox(height: AppSizes.p8),
            TopicTag(label: group.topic),
            const SizedBox(height: AppSizes.p16),
            CustomButton(
              text: 'View Details',
              isPrimary: false,
              onPressed: () => context.push('/groups/detail', extra: group),
            ),
          ],
        ),
      ),
    );
  }
}
