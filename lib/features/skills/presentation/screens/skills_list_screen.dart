// lib/features/skills/presentation/screens/skills_list_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/skill_widgets.dart';
import '../../models/skill_model.dart';

class SkillsListScreen extends StatefulWidget {
  const SkillsListScreen({super.key});

  @override
  State<SkillsListScreen> createState() => _SkillsListScreenState();
}

class _SkillsListScreenState extends State<SkillsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<SkillModel> _skills = [
    SkillModel(
      id: '1',
      title: 'Java Tutoring',
      category: 'Programming',
      categoryColor: Color(0xFFD6EAF8),
      categoryTextColor: Color(0xFF2E86C1),
      description:
          'Offering help with core Java concepts, object-oriented programming, and debugging assignments.',
      ownerName: 'Solomon Elias',
      ownerYear: 'Computer Science, Year 3',
    ),
    SkillModel(
      id: '2',
      title: 'Conversational Spanish',
      category: 'Language',
      categoryColor: Color(0xFFF9EBEA),
      categoryTextColor: Color(0xFFC0392B),
      description:
          'Native Spanish speaker looking to exchange language practice for help with introductory Calculus.',
      ownerName: 'Ruth Tewodros',
      ownerYear: 'Languages, Year 2',
    ),
    SkillModel(
      id: '3',
      title: 'Figma UI/UX Design',
      category: 'Design',
      categoryColor: Color(0xFFF5EEF8),
      categoryTextColor: Color(0xFF8E44AD),
      description:
          'Can teach the basics of UI/UX design and prototyping using Figma for your app projects.',
      ownerName: 'Yordanos Bisrat',
      ownerYear: 'Software Engineering, Year 3',
    ),
    SkillModel(
      id: '4',
      title: 'Calculus II Help',
      category: 'Math',
      categoryColor: Color(0xFFE8F8F5),
      categoryTextColor: Color(0xFF1E8449),
      description:
          'Available to explain integrals, series, and complex problem-solving strategies for Calculus.',
      ownerName: 'Henok Tewodros',
      ownerYear: 'Mathematics, Year 4',
    ),
  ];

  List<SkillModel> get _filteredSkills {
    if (_searchQuery.isEmpty) return _skills;
    return _skills
        .where(
          (s) =>
              s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.category.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.tune, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search Bar ───────────────────────────────────────────
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
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
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

          // ── Skills List ──────────────────────────────────────────
          Expanded(
            child: _filteredSkills.isEmpty
                ? const EmptySkillsWidget()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                      vertical: AppSizes.p8,
                    ),
                    itemCount: _filteredSkills.length,
                    itemBuilder: (context, index) {
                      final skill = _filteredSkills[index];
                      return SkillListCard(
                        skill: skill,
                        onViewDetails: () {
                          context.push('/skills/detail', extra: skill);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    const labels = ['Home', 'Skills', 'Groups', 'Profile'];
    const icons = [
      Icons.home_outlined,
      Icons.lightbulb_outline,
      Icons.group_outlined,
      Icons.person_outline,
    ];
    const routes = ['/home', '/skills', '/groups', '/profile'];

    return BottomNavigationBar(
      currentIndex: 1,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      backgroundColor: AppColors.background,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      onTap: (index) => context.go(routes[index]),
      items: List.generate(
        labels.length,
        (i) => BottomNavigationBarItem(icon: Icon(icons[i]), label: labels[i]),
      ),
    );
  }
}

// ── Empty Skills Widget ───────────────────────────────────────────────────────
class EmptySkillsWidget extends StatelessWidget {
  const EmptySkillsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inbox_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.p16),
            const Text(
              'No skills posted yet',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: AppSizes.p8),
            const Text(
              'Be the first to share your skill with others',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
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
