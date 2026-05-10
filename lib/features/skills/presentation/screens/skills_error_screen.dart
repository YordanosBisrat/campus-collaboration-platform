import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/app_bottom_nav.dart';

class SkillsErrorScreen extends StatelessWidget {
  const SkillsErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Skills'),
      ),
      body: ErrorState(
        title: 'Failed to load data',
        subtitle:
            "We couldn't load the skills list. Please check your connection and try again.",
        onRetry: () {},
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}