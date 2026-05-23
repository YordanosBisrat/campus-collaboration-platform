import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/database/app_database.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/skill_widgets.dart';

class SkillRequestsScreen extends ConsumerStatefulWidget {
  const SkillRequestsScreen({super.key});

  @override
  ConsumerState<SkillRequestsScreen> createState() =>
      _SkillRequestsScreenState();
}

class _SkillRequestsScreenState extends ConsumerState<SkillRequestsScreen> {
  List<Map<String, dynamic>> _requests = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      setState(() => _loading = false);
      return;
    }

    try {
      final db = await AppDatabase.instance.database;
      final rows = await db.rawQuery(
        '''
        SELECT sr.id, sr.requester_name, sr.skill_title, sr.status, sr.skill_id
        FROM skill_requests sr
        INNER JOIN skills s ON sr.skill_id = s.id
        WHERE s.owner_id = ?
        ORDER BY sr.created_at DESC
      ''',
        [user.id],
      );

      setState(() {
        _requests = rows.map((r) => Map<String, dynamic>.from(r)).toList();
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _onAccept(int index) {
    setState(() => _requests.removeAt(index));
    showSuccessSnackBar(context, 'Request accepted!');
  }

  void _onReject(int index) {
    setState(() => _requests.removeAt(index));
    showInfoSnackBar(context, 'Request rejected.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _requests.isEmpty
          ? const Center(
              child: Text(
                'No pending requests',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSizes.p16),
              itemCount: _requests.length,
              itemBuilder: (_, i) {
                final req = _requests[i];
                return SkillRequestCard(
                  requesterName: req['requester_name'] as String,
                  skillRequested: req['skill_title'] as String,
                  onAccept: () => _onAccept(i),
                  onReject: () => _onReject(i),
                );
              },
            ),
    );
  }
}
