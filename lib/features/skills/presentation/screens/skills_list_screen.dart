import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_bottom_nav.dart';

// ── Data model ────────────────────────────────────────────────────────────────

class SkillItem {
  final String title;
  final String category;
  final Color badgeColor;
  final Color badgeTextColor;
  final String description;
  final String userName;
  final Color avatarBg;
  final Color avatarFg;

  const SkillItem({
    required this.title,
    required this.category,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.description,
    required this.userName,
    required this.avatarBg,
    required this.avatarFg,
  });
}

final List<SkillItem> skills = [
  const SkillItem(
    title: 'Java Tutoring',
    category: 'Programming',
    badgeColor: Color(0xFFE8F0FE),
    badgeTextColor: Color(0xFF3B5BDB),
    description:
        'Offering help with core Java concepts, object-oriented programming, and debugging assignments.',
    userName: 'Solomon Elias',
    avatarBg: Color(0xFFD1C4E9),
    avatarFg: Color(0xFF9575CD),
  ),
  const SkillItem(
    title: 'Conversational Spanish',
    category: 'Language',
    badgeColor: Color(0xFFFFF0F6),
    badgeTextColor: Color(0xFFD6336C),
    description:
        'Native Spanish speaker looking to exchange language practice for help with introductory Calculus.',
    userName: 'Ruth Tewodros',
    avatarBg: Color(0xFFFCE4EC),
    avatarFg: Color(0xFFF06292),
  ),
  const SkillItem(
    title: 'Figma UI/UX Design',
    category: 'Design',
    badgeColor: Color(0xFFF0FFF4),
    badgeTextColor: Color(0xFF2F9E44),
    description:
        'Can teach the basics of UI/UX design and prototyping using Figma for your app projects.',
    userName: 'Yordanos Bisrat',
    avatarBg: Color(0xFFE8F5E9),
    avatarFg: Color(0xFF66BB6A),
  ),
  const SkillItem(
    title: 'Calculus II Help',
    category: 'Math',
    badgeColor: Color(0xFFF3F0FF),
    badgeTextColor: Color(0xFF7048E8),
    description:
        'Available to explain integrals, series, and complex problem-solving strategies for Calculus.',
    userName: 'Henok Tewodros',
    avatarBg: Color(0xFFEDE7F6),
    avatarFg: Color(0xFF7E57C2),
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class SkillListScreen extends StatefulWidget {
  const SkillListScreen({super.key});

  @override
  State<SkillListScreen> createState() => _SkillListScreenState();
}

class _SkillListScreenState extends State<SkillListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Skills'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.p16),
            child: SkillFilterIcon(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSizes.p16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                border: Border.all(color: AppColors.divider),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p12,
                vertical: AppSizes.p8,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: AppSizes.p8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search skills...',
                        hintStyle: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Skills list ─────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p16,
                vertical: AppSizes.p8,
              ),
              itemCount: skills.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSizes.p12),
              itemBuilder: (context, index) =>
                  SkillCard(skill: skills[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}

// ── Filter Icon ───────────────────────────────────────────────────────────────

class SkillFilterIcon extends StatelessWidget {
  const SkillFilterIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _line(20),
          const SizedBox(height: 4),
          _line(14),
          const SizedBox(height: 4),
          _line(18),
        ],
      ),
    );
  }

  Widget _line(double width) => Container(
        width: width,
        height: 2,
        decoration: BoxDecoration(
          color: AppColors.textSecondary,
          borderRadius: BorderRadius.circular(2),
        ),
      );
}

// ── Skill Card ────────────────────────────────────────────────────────────────

class SkillCard extends StatelessWidget {
  final SkillItem skill;

  const SkillCard({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  skill.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.p8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: skill.badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  skill.category,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: skill.badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p8),

          // Description
          Text(
            skill.description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSizes.p12),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: skill.avatarBg,
                    child: Icon(
                      Icons.person,
                      size: 18,
                      color: skill.avatarFg,
                    ),
                  ),
                  const SizedBox(width: AppSizes.p8),
                  Text(
                    skill.userName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.p16,
                    vertical: AppSizes.p8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('View Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}