import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/group_entity.dart';
import '../providers/groups_provider.dart';

class GroupListScreen extends ConsumerStatefulWidget {
  const GroupListScreen({super.key});

  @override
  ConsumerState<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends ConsumerState<GroupListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(groupsProvider);

    List<GroupEntity> groups = [];
    bool loading = false;
    String? error;

    if (state is GroupsLoading) loading = true;
    if (state is GroupsLoaded) groups = state.groups;
    if (state is GroupsError) error = state.message;

    return Scaffold(
      appBar: AppBar(title: const Text('Groups')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(hintText: 'Search groups...'),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(child: Text(error))
                    : Builder(builder: (context) {
                        final q = _searchController.text.toLowerCase();
                        final displayed = q.isEmpty
                            ? groups
                            : groups
                                .where((g) =>
                                    g.name.toLowerCase().contains(q) ||
                                    g.topic.toLowerCase().contains(q))
                                .toList();
                        if (displayed.isEmpty) {
                          return const Center(child: Text('No groups'));
                        }
                        return ListView.builder(
                          itemCount: displayed.length,
                          itemBuilder: (_, i) => ListTile(
                            title: Text(displayed[i].name),
                            subtitle: Text(displayed[i].topic),
                            trailing: Text('${displayed[i].memberCount}'),
                            onTap: () {
                              // Navigate using Navigator; router may override
                            },
                          ),
                        );
                      }),
          ),
        ],
      ),
    );
  }
}