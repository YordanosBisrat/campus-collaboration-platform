import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_collaboration_app/features/auth/presentation/providers/auth_provider.dart';

import '../../domain/entities/group_entity.dart';
import '../providers/groups_provider.dart';
import 'edit_group_screen.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  final GroupEntity group;

  const GroupDetailScreen({super.key, required this.group});

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen> {
  late bool _isMember;
  late int _memberCount;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final currentUser = ref.read(currentUserProvider);
    _memberCount = widget.group.memberCount;
    _isMember = currentUser != null &&
        (widget.group.memberIds.contains(currentUser.id) ||
            currentUser.id == widget.group.creatorId);
  }

  Future<void> _toggleMembership() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final notifier = ref.read(groupsProvider.notifier);
    final err = _isMember
        ? await notifier.leaveGroup(groupId: widget.group.id)
        : await notifier.joinGroup(groupId: widget.group.id);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (err == null) {
      setState(() {
        _isMember = !_isMember;
        _memberCount += _isMember ? 1 : -1;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isMember
                  ? 'Joined "${widget.group.name}"!'
                  : 'Left "${widget.group.name}".',
            ),
          ),
        );
      }
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }

  Future<void> _deleteGroup() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final err = await ref.read(groupsProvider.notifier).deleteGroup(widget.group.id);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (err == null) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${widget.group.name}" deleted.')),
        );
      }
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final isCreator = currentUser?.id == widget.group.creatorId;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: [
          if (isCreator)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditGroupScreen(group: widget.group),
                ),
              ),
            ),
          if (isCreator)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteGroup,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.topic,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(widget.group.description),
            const SizedBox(height: 12),
            Text('Members: $_memberCount'),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _toggleMembership,
          child: _isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isMember ? 'Leave Group' : 'Join Group'),
        ),
      ),
    );
  }
}