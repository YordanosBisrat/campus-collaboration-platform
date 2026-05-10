// lib/features/skills/presentation/screens/skill_requests_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/skill_widgets.dart';

class SkillRequestsScreen extends StatefulWidget {
  const SkillRequestsScreen({super.key});

  @override
  State<SkillRequestsScreen> createState() => _SkillRequestsScreenState();
}

class _SkillRequestsScreenState extends State<SkillRequestsScreen> {
  // Mock requests data matching Figma
  final List<Map<String, String>> _requests = [
    {'name': 'Solomon Elias', 'skill': 'Java Tutoring'},
    {'name': 'Christian Elias', 'skill': 'UI Design Basics'},
    {'name': 'Elias Bisrat', 'skill': 'Calculus Help'},
    {'name': 'Ruth Tewodros', 'skill': 'Java Tutoring'},
  ];

  void _onAccept(int index) {
    setState(() => _requests.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request accepted!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _onReject(int index) {
    setState(() => _requests.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request rejected.'),
        backgroundColor: AppColors.textSecondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ── App Bar ──────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Requests',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),

      body: _requests.isEmpty
          ? const Center(
              child: Text(
                'No pending requests',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSizes.p16),
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                final request = _requests[index];
                return SkillRequestCard(
                  requesterName: request['name']!,
                  skillRequested: request['skill']!,
                  onAccept: () => _onAccept(index),
                  onReject: () => _onReject(index),
                );
              },
            ),
    );
  }
}
