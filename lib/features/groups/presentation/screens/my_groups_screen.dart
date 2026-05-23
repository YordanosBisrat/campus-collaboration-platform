import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/group_entity.dart';
import '../providers/groups_provider.dart';

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
                trailing: Text('${groups[i].memberCount} members'),
                onTap: () => context.push('/groups/detail', extra: groups[i]),
              ),
            ),
    );
  }
}
