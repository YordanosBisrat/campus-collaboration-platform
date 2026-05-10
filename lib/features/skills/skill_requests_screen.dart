import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_bottom_nav.dart';

class SkillRequestsScreen extends StatefulWidget {
  const SkillRequestsScreen({super.key});

  @override
  State<SkillRequestsScreen> createState() => _SkillRequestsScreenState();
}

class _SkillRequestsScreenState extends State<SkillRequestsScreen> {
  final List<Map<String, dynamic>> _requests = [
    {
      'id': '1',
      'name': 'Solomon Elias',
      'requestedSkill': 'Java Tutoring',
      'status': 'pending',
    },
    {
      'id': '2',
      'name': 'Christian Elias',
      'requestedSkill': 'UI Design Basics',
      'status': 'pending',
    },
    {
      'id': '3',
      'name': 'Elias Bisrat',
      'requestedSkill': 'Calculus Help',
      'status': 'pending',
    },
    {
      'id': '4',
      'name': 'Ruth Tewodros',
      'requestedSkill': 'Java Tutoring',
      'status': 'pending',
    },
  ];

  void _handleAccept(String id) {
    setState(() {
      final index = _requests.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        _requests[index]['status'] = 'accepted';
      }
    });
  }

  void _handleReject(String id) {
    setState(() {
      final index = _requests.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        _requests[index]['status'] = 'rejected';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Requests'),
      ),
      body: _requests.isEmpty
          ? const Center(
              child: Text(
                'No requests yet',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSizes.p16),
              itemCount: _requests.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSizes.p8),
              itemBuilder: (context, index) {
                final request = _requests[index];
                return RequestItem(
                  name: request['name'],
                  requestedSkill: request['requestedSkill'],
                  status: request['status'],
                  onAccept: () => _handleAccept(request['id']),
                  onReject: () => _handleReject(request['id']),
                );
              },
            ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}

// ── Request Item ──────────────────────────────────────────────────────────────

class RequestItem extends StatelessWidget {
  final String name;
  final String requestedSkill;
  final String status;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const RequestItem({
    super.key,
    required this.name,
    required this.requestedSkill,
    required this.status,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // ── Person info row ──────────────────────────────
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.p12),

              // Name + skill
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Requested: $requestedSkill',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.p16),

          // ── Action buttons or status ─────────────────────
          if (status == 'pending')
            Row(
              children: [
                // Reject button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.divider),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusSmall),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.p12),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.p12),

                // Accept button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusSmall),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.p12),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            // Status badge after action
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSizes.p12),
              decoration: BoxDecoration(
                color: status == 'accepted'
                    ? AppColors.successLight
                    : AppColors.errorLight,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Text(
                status == 'accepted' ? '✓ Accepted' : '✗ Rejected',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: status == 'accepted'
                      ? AppColors.success
                      : AppColors.error,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}