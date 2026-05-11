import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/widgets/category_chip.dart';

class SearchResultsScreen extends StatefulWidget {
  final String initialQuery;

  const SearchResultsScreen({super.key, this.initialQuery = ''});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _searchController;
  String _selectedFilter = 'All Results';

  final List<String> _filters = ['All Results', 'Skills', 'Study Groups'];

  final List<Map<String, dynamic>> _results = [
    {
      'title': 'Java Programming Tutoring for Beginners',
      'type': 'Skill',
      'description':
          'I can help you understand the basics of Java programming, including object-oriented...',
      'person': 'Alex Johnson',
      'members': null,
    },
    {
      'title': 'Advanced Java & Data Structures Study Group',
      'type': 'Group',
      'description':
          'We meet every Tuesday to practice LeetCode problems in Java and discuss data...',
      'person': null,
      'members': 8,
    },
    {
      'title': 'Java Spring Boot Web Development',
      'type': 'Skill',
      'description':
          'Learn how to build RESTful APIs and microservices using Java Spring Boot. I have...',
      'person': 'Sarah Chen',
      'members': null,
    },
    {
      'title': 'Java Final Exam Prep',
      'type': 'Group',
      'description':
          'Study group focused on preparing for the CS102 final exam. We will review past papers...',
      'person': null,
      'members': 4,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredResults {
    if (_selectedFilter == 'All Results') return _results;
    if (_selectedFilter == 'Skills') {
      return _results.where((r) => r['type'] == 'Skill').toList();
    }
    return _results.where((r) => r['type'] == 'Group').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: _SearchBar(controller: _searchController),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => _searchController.clear(),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: AppSizes.p12,
            ),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSizes.p8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.p16,
                        vertical: AppSizes.p8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusLarge,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.divider,
                        ),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          //  Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            child: Text(
              '${_filteredResults.length} results found',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: AppSizes.p8),

          //  Results List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p16,
                vertical: AppSizes.p8,
              ),
              itemCount: _filteredResults.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSizes.p8),
              itemBuilder: (context, index) {
                final item = _filteredResults[index];
                return SearchResultItem(
                  title: item['title'],
                  type: item['type'],
                  description: item['description'],
                  person: item['person'],
                  members: item['members'],
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//  Search Bar

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        decoration: const InputDecoration(
          hintText: 'Search skills or groups...',
          hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 20,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}

//  Search Result Item

class SearchResultItem extends StatelessWidget {
  final String title;
  final String type;
  final String description;
  final String? person;
  final int? members;
  final VoidCallback onTap;

  const SearchResultItem({
    super.key,
    required this.title,
    required this.type,
    required this.description,
    this.person,
    this.members,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSkill = type == 'Skill';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Type chip
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.p8),
                CategoryChip(label: type),
              ],
            ),

            const SizedBox(height: AppSizes.p8),

            // Description
            Text(
              description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppSizes.p12),

            // Person / members + View Details
            Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.person, size: 14, color: AppColors.primary),
                ),
                const SizedBox(width: AppSizes.p8),
                Expanded(
                  child: Text(
                    isSkill ? (person ?? '') : '${members ?? 0} members',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
