import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/skills_provider.dart';
import '../../data/models/skill_model.dart';
import '../../domain/entities/skill_entity.dart';
import '../widgets/skill_widgets.dart';

class SkillsListScreen extends ConsumerStatefulWidget {
  const SkillsListScreen({super.key});

  @override
  ConsumerState<SkillsListScreen> createState() => _SkillsListScreenState();
}

class _SkillsListScreenState extends ConsumerState<SkillsListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SkillEntity> _filtered(List<SkillEntity> skills) {
    if (_searchQuery.isEmpty) return skills;
    final q = _searchQuery.toLowerCase();
    return skills
        .where(
          (s) =>
              s.title.toLowerCase().contains(q) ||
              s.category.toLowerCase().contains(q) ||
              s.ownerName.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(skillsProvider);

    List<SkillEntity> skills = [];
    bool loading = false;
    String? error;

    if (state is SkillsLoading) loading = true;
    if (state is SkillsLoaded) skills = state.skills;
    if (state is SkillsOperationLoading) skills = state.previousSkills;
    if (state is SkillsError) error = state.message;

    final displayed = _filtered(skills);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSizes.p16,
        title: const Text(
          'Skills',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person_outlined,
              color: AppColors.textPrimary,
            ),
            tooltip: 'My Skills',
            onPressed: () => context.push('/skills/my-skills'),
          ),
          IconButton(
            icon: const Icon(
              Icons.inbox_outlined,
              color: AppColors.textPrimary,
            ),
            tooltip: 'Requests',
            onPressed: () => context.push('/skills/requests'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: AppSizes.p8,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search skills...',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),

          // Body
          Expanded(
            child: loading
                ? const ShimmerList()
                : error != null
                ? _ErrorBody(
                    onRetry: () => ref.read(skillsProvider.notifier).refresh(),
                  )
                : displayed.isEmpty
                ? _EmptySkillsState()
                : RefreshIndicator(
                    onRefresh: () =>
                        ref.read(skillsProvider.notifier).refresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.p16,
                        vertical: AppSizes.p8,
                      ),
                      itemCount: displayed.length,
                      itemBuilder: (_, i) {
                        final skill = SkillModel.fromEntity(displayed[i]);
                        return SkillListCard(
                          skill: skill,
                          onViewDetails: () =>
                              context.push('/skills/detail', extra: skill),
                        );
                      },
                    ),
                  ),
          ),
        ],
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
}

class _ErrorBody extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorBody({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSizes.p24),
            const Text(
              'Failed to load skills',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.p8),
            const Text(
              "Check your connection and try again.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.p24),
            SizedBox(
              width: 140,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                ),
                icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                label: const Text(
                  'Retry',
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

class _EmptySkillsState extends StatelessWidget {
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
                Icons.inbox_outlined,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.p24),
            const Text(
              'No skills posted yet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.p8),
            const Text(
              'Be the first to share your skill with others',
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
