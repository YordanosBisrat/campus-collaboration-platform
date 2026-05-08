// lib/features/groups/models/group_model.dart

enum MemberRole { admin, member }

class GroupMember {
  final String id;
  final String name;
  final String field;
  final MemberRole role;

  const GroupMember({
    required this.id,
    required this.name,
    required this.field,
    required this.role,
  });
}

class GroupModel {
  final String id;
  final String name;
  final String topic;
  final String description;
  final int memberCount;
  final List<GroupMember> members;

  const GroupModel({
    required this.id,
    required this.name,
    required this.topic,
    required this.description,
    required this.memberCount,
    this.members = const [],
  });
}

// ---------------------------------------------------------------------------
// Mock data — replace with real repository calls when backend is ready
// ---------------------------------------------------------------------------

class GroupMockData {
  GroupMockData._();

  static const List<GroupMember> _mlMembers = [
    GroupMember(id: 'm1', name: 'Chrstian Elias',    field: 'Computer Science',       role: MemberRole.admin),
    GroupMember(id: 'm2', name: 'Hiruy Tiku',         field: 'Data Science',           role: MemberRole.member),
    GroupMember(id: 'm3', name: 'Menal Abdulkadir',   field: 'Mathematics',            role: MemberRole.member),
    GroupMember(id: 'm4', name: 'Sara Bekele',        field: 'Electrical Engineering', role: MemberRole.member),
    GroupMember(id: 'm5', name: 'Liya Haile',         field: 'Software Engineering',   role: MemberRole.member),
  ];

  static const GroupModel advancedML = GroupModel(
    id: 'g0',
    name: 'Advanced Machine Learning',
    topic: 'Computer Science',
    description:
        'A dedicated study group for discussing advanced topics in machine '
        'learning, reviewing research papers, and collaborating on deep '
        'learning projects. Meets every Tuesday evening at the main campus library.',
    memberCount: 12,
    members: _mlMembers,
  );

  static const List<GroupModel> allGroups = [
    GroupModel(id: 'g1', name: 'Data Structures Study',      topic: 'Computer Science', description: 'A focused group on data structures and algorithms, working through problem sets and interview prep.', memberCount: 12),
    GroupModel(id: 'g2', name: 'Calculus II Prep',           topic: 'Mathematics',      description: 'Weekly sessions covering integral calculus, series, and exam preparation strategies.',               memberCount: 8),
    GroupModel(id: 'g3', name: 'Intro to Psychology',        topic: 'Psychology',       description: 'An introductory study group exploring the foundations of psychological theory and research.',         memberCount: 24),
    GroupModel(id: 'g4', name: 'Marketing 101 Case Study',   topic: 'Business',         description: 'Analysing real-world marketing campaigns to deepen our understanding of brand strategy.',             memberCount: 15),
  ];

  static const List<GroupModel> myGroups = [
    GroupModel(id: 'g5', name: 'Advanced Data Structures',       topic: 'Computer Science', description: 'Deep dive into advanced data structures and system design.', memberCount: 14),
    GroupModel(id: 'g6', name: 'Spanish Conversation Practice',  topic: 'Languages',        description: 'Practice conversational Spanish with native and learner peers.', memberCount: 8),
    GroupModel(id: 'g7', name: 'Figma & UI Design Enthusiasts',  topic: 'Design',           description: 'Share Figma tips, critique designs, and grow together as UI designers.', memberCount: 22),
    GroupModel(id: 'g8', name: 'Calculus 101 Midterm Prep',      topic: 'Mathematics',      description: 'Collaborative midterm preparation for Calculus 101.', memberCount: 5),
  ];
}


