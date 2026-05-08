// lib/features/groups/presentation/screens/group_list_screen.dart
// Screen: Study Groups — root tab for the Groups feature.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../models/group_model.dart';
import '../widgets/group_widgets.dart';

class GroupListScreen extends StatefulWidget {
  const GroupListScreen({super.key});

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  final _searchController = TextEditingController();
  List<GroupModel> _displayed = GroupMockData.allGroups;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _displayed = q.isEmpty
          ? GroupMockData.allGroups
          : GroupMockData.allGroups
              .where((g) =>
                  g.name.toLowerCase().contains(q) ||
                  g.topic.toLowerCase().contains(q))
              .toList();
    });
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
        automaticallyImplyLeading: false,
        title: Text(
          'Study Groups',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      // ── Body ─────────────────────────────────────────────────────────────
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(
                AppSizes.p16, AppSizes.p8, AppSizes.p16, AppSizes.p16),
            child: TextField(
              controller: _searchController,
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search study groups...',
                hintStyle:
                    TextStyle(color: AppColors.textSecondary, fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded,
                    color: AppColors.textSecondary, size: 20),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.p16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusMedium),
                  borderSide:
                      BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // Group cards
          Expanded(
            child: _displayed.isEmpty
                ? Center(
                    child: Text('No groups match your search',
                        style: TextStyle(color: AppColors.textSecondary)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                        AppSizes.p16, AppSizes.p8, AppSizes.p16, 100),
                    itemCount: _displayed.length,
                    itemBuilder: (context, index) =>
                        _GroupListCard(group: _displayed[index]),
                  ),
          ),
        ],
      ),

      // ── FAB ──────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/groups/create'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        child: const Icon(Icons.add, size: 26),
      ),

      // ── Bottom Nav ────────────────────────────────────────────────────────
      bottomNavigationBar: _BottomNav(currentIndex: 2),
    );
  }
}

// ---------------------------------------------------------------------------
// Group List Card
// ---------------------------------------------------------------------------

/// Card with outlined "View Details" button — matches the Figma Group List design.
class _GroupListCard extends StatelessWidget {
  final GroupModel group;
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
            // Title + member chip
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: AppSizes.p8),
                MemberCountChip(count: group.memberCount),
              ],
            ),

            const SizedBox(height: AppSizes.p8),
            TopicTag(label: group.topic),
            const SizedBox(height: AppSizes.p16),

            // Outlined view details button
            CustomButton(
              text: 'View Details',
              isPrimary: false,
              onPressed: () =>
                  context.push('/groups/detail', extra: group),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom Navigation Bar
// ---------------------------------------------------------------------------

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      onTap: (i) {
        switch (i) {
          case 0: context.go('/home');    break;
          case 1: context.go('/skills');  break;
          case 2: context.go('/groups');  break;
          case 3: context.go('/profile'); break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined),        activeIcon: Icon(Icons.home_rounded),        label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined),   activeIcon: Icon(Icons.menu_book_rounded),   label: 'Skills'),
        BottomNavigationBarItem(icon: Icon(Icons.group_outlined),       activeIcon: Icon(Icons.group_rounded),       label: 'Groups'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded),    label: 'Profile'),
      ],
    );
  }
}

