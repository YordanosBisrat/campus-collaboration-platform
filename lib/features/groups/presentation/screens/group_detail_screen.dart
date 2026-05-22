import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_collaboration_app/features/auth/presentation/providers/auth_provider.dart';

import '../../domain/entities/group_entity.dart';
import '../providers/groups_provider.dart';
import 'edit_group_screen.dart';

class GroupDetailScreen extends ConsumerWidget {
  final GroupEntity group;

  const GroupDetailScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(currentUserProvider);
    final isCreator = currentUser?.id == group.creatorId;
    final isMember = group.memberCount > 0 && (currentUser?.id != null && group.creatorId == currentUser?.id ? true : false);

    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        actions: [
          if (isCreator)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditGroupScreen(group: group))),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(group.topic, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(group.description),
            const SizedBox(height: 12),
            Text('Members: ${group.memberCount}'),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: () async {
            final notifier = ref.read(groupsProvider.notifier);
            final err = isMember
                ? await notifier.leaveGroup(groupId: group.id)
                : await notifier.joinGroup(groupId: group.id);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err == null ? (isMember ? 'Left group' : 'Joined "${group.name}"!') : 'Something went wrong')));
          },
          child: Text(isMember ? 'Leave Group' : 'Join Group'),
        ),
      ),
    );
  }
}