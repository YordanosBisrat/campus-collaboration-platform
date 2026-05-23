// lib/features/groups/data/datasources/group_remote_datasource.dart
// Mock remote datasource — simulates network responses.
// Replace method bodies with real HTTP calls when backend is ready.
// The interface stays identical.

import 'package:uuid/uuid.dart';

import '../models/group_model.dart';

class GroupRemoteDatasource {
  final _uuid = const Uuid();

  // Simulated network delay
  Future<void> get _delay => Future.delayed(const Duration(milliseconds: 350));

  // In-memory store simulating a remote database
  final List<GroupModel> _groups = [
    GroupModel(
      id: 'g1',
      name: 'Data Structures Study',
      topic: 'Computer Science',
      description: 'A focused group on data structures and algorithms, working through problem sets and interview prep.',
      creatorId: 'seed-user-1',
      memberCount: 2,
      createdAt: DateTime(2025, 1, 10).millisecondsSinceEpoch,
    ),
    GroupModel(
      id: 'g2',
      name: 'Calculus II Prep',
      topic: 'Mathematics',
      description: 'Weekly sessions covering integral calculus, series, and exam preparation strategies.',
      creatorId: 'seed-user-2',
      memberCount: 2,
      createdAt: DateTime(2025, 1, 15).millisecondsSinceEpoch,
    ),
    GroupModel(
      id: 'g3',
      name: 'Intro to Psychology',
      topic: 'Psychology',
      description: 'An introductory study group exploring the foundations of psychological theory and research.',
      creatorId: 'seed-user-3',
      memberCount: 1,
      createdAt: DateTime(2025, 1, 20).millisecondsSinceEpoch,
    ),
    GroupModel(
      id: 'g4',
      name: 'Marketing 101 Case Study',
      topic: 'Business',
      description: 'Analysing real-world marketing campaigns to deepen our understanding of brand strategy.',
      creatorId: 'seed-user-1',
      memberCount: 1,
      createdAt: DateTime(2025, 2, 1).millisecondsSinceEpoch,
    ),
  ];

  final List<GroupMemberModel> _members = [
    GroupMemberModel(id: 'm1', groupId: 'g1', userId: 'seed-user-1', userName: 'Chrstian Elias', userField: 'Computer Science', role: 'admin',  joinedAt: DateTime(2025, 1, 10).millisecondsSinceEpoch),
    GroupMemberModel(id: 'm2', groupId: 'g1', userId: 'seed-user-2', userName: 'Hiruy Tiku',     userField: 'Data Science',      role: 'member', joinedAt: DateTime(2025, 1, 11).millisecondsSinceEpoch),
    GroupMemberModel(id: 'm3', groupId: 'g2', userId: 'seed-user-2', userName: 'Hiruy Tiku',     userField: 'Data Science',      role: 'admin',  joinedAt: DateTime(2025, 1, 15).millisecondsSinceEpoch),
    GroupMemberModel(id: 'm4', groupId: 'g2', userId: 'seed-user-3', userName: 'Menal Abdulkadir', userField: 'Mathematics',     role: 'member', joinedAt: DateTime(2025, 1, 16).millisecondsSinceEpoch),
    GroupMemberModel(id: 'm5', groupId: 'g3', userId: 'seed-user-3', userName: 'Menal Abdulkadir', userField: 'Mathematics',     role: 'admin',  joinedAt: DateTime(2025, 1, 20).millisecondsSinceEpoch),
    GroupMemberModel(id: 'm6', groupId: 'g4', userId: 'seed-user-1', userName: 'Chrstian Elias', userField: 'Computer Science', role: 'admin',  joinedAt: DateTime(2025, 2, 1).millisecondsSinceEpoch),
  ];

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<List<GroupModel>> fetchAllGroups() async {
    await _delay;
    return List.unmodifiable(_groups);
  }

  Future<GroupModel?> fetchGroupById(String id) async {
    await _delay;
    try {
      return _groups.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<GroupMemberModel>> fetchGroupMembers(String groupId) async {
    await _delay;
    return _members.where((m) => m.groupId == groupId).toList();
  }

  // ── Create ────────────────────────────────────────────────────────────────

  Future<GroupModel> createGroup({
    required String name,
    required String topic,
    required String description,
    required String creatorId,
    required String creatorName,
    required String creatorField,
  }) async {
    await _delay;
    final now = DateTime.now().millisecondsSinceEpoch;
    final groupId = _uuid.v4();

    final group = GroupModel(
      id: groupId,
      name: name,
      topic: topic,
      description: description,
      creatorId: creatorId,
      memberCount: 1, // creator is first member
      createdAt: now,
    );

    final member = GroupMemberModel(
      id: _uuid.v4(),
      groupId: groupId,
      userId: creatorId,
      userName: creatorName,
      userField: creatorField,
      role: 'admin',
      joinedAt: now,
    );

    _groups.add(group);
    _members.add(member);
    return group;
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<GroupModel> updateGroup({
    required String groupId,
    required String name,
    required String topic,
    required String description,
  }) async {
    await _delay;
    final index = _groups.indexWhere((g) => g.id == groupId);
    if (index == -1) throw Exception('Group not found');

    final updated = _groups[index].copyWith(
      name: name,
      topic: topic,
      description: description,
    );
    _groups[index] = updated;
    return updated;
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> deleteGroup(String groupId) async {
    await _delay;
    _groups.removeWhere((g) => g.id == groupId);
    _members.removeWhere((m) => m.groupId == groupId);
  }

  // ── Membership ────────────────────────────────────────────────────────────

  Future<GroupMemberModel> joinGroup({
    required String groupId,
    required String userId,
    required String userName,
    required String userField,
  }) async {
    await _delay;

    // Check if already a member
    final exists = _members.any(
      (m) => m.groupId == groupId && m.userId == userId,
    );
    if (exists) throw Exception('Already a member of this group');

    final member = GroupMemberModel(
      id: _uuid.v4(),
      groupId: groupId,
      userId: userId,
      userName: userName,
      userField: userField,
      role: 'member',
      joinedAt: DateTime.now().millisecondsSinceEpoch,
    );
    _members.add(member);

    // Increment count in remote store
    final gi = _groups.indexWhere((g) => g.id == groupId);
    if (gi != -1) {
      _groups[gi] = _groups[gi].copyWith(memberCount: _groups[gi].memberCount + 1);
    }

    return member;
  }

  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    await _delay;
    _members.removeWhere(
      (m) => m.groupId == groupId && m.userId == userId,
    );

    // Decrement count in remote store
    final gi = _groups.indexWhere((g) => g.id == groupId);
    if (gi != -1 && _groups[gi].memberCount > 0) {
      _groups[gi] = _groups[gi].copyWith(memberCount: _groups[gi].memberCount - 1);
    }
  }
}