import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/groups_provider.dart';
import '../../domain/entities/group_entity.dart';

// Temporary placeholder to satisfy analyzer when older references exist.
// Presentation uses `GroupEntity` / `GroupViewModel`; remove if unused.
class GroupModel {}

class MyGroupsScreen extends ConsumerWidget {
  const MyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myGroupsProvider);

    if (state is MyGroupsLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state is MyGroupsError) {
      return const Scaffold(body: Center(child: Text('Failed to load your groups')));
    }
    final groups = (state is MyGroupsLoaded) ? state.groups : <GroupEntity>[];

    return Scaffold(
      appBar: AppBar(title: const Text('My Groups')),
      body: groups.isEmpty
          ? const Center(child: Text('You are not a member of any groups'))
          : ListView.builder(
              itemCount: groups.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(groups[i].name),
                subtitle: Text(groups[i].topic),
              ),
            ),
    );
  }
}
