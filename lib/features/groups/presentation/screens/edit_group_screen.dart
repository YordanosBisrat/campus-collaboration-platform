import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/group_entity.dart';
import '../providers/groups_provider.dart';

class EditGroupScreen extends ConsumerStatefulWidget {
  final GroupEntity group;

  const EditGroupScreen({super.key, required this.group});

  @override
  ConsumerState<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends ConsumerState<EditGroupScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _topicCtrl;
  late final TextEditingController _descCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.group.name);
    _topicCtrl = TextEditingController(text: widget.group.topic);
    _descCtrl = TextEditingController(text: widget.group.description);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _topicCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final err = await ref.read(groupsProvider.notifier).updateGroup(
          groupId: widget.group.id,
          name: _nameCtrl.text.trim(),
          topic: _topicCtrl.text.trim(),
          description: _descCtrl.text.trim(),
        );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (err == null) Navigator.of(context).pop();
    if (err != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Group')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 8),
            TextField(controller: _topicCtrl, decoration: const InputDecoration(labelText: 'Topic')),
            const SizedBox(height: 8),
            TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Description'), maxLines: 4),
            const SizedBox(height: 16),
            _isLoading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _submit, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
