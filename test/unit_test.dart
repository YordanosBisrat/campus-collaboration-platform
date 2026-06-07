import 'package:flutter_test/flutter_test.dart';
import 'package:campus_collaboration_app/features/auth/presentation/providers/auth_state.dart';
import 'package:campus_collaboration_app/features/skills/presentation/providers/skills_provider.dart';
import 'package:campus_collaboration_app/features/groups/presentation/providers/groups_provider.dart';
import 'package:campus_collaboration_app/features/auth/domain/entities/user_entity.dart';
import 'package:campus_collaboration_app/features/skills/domain/entities/skill_entity.dart';
import 'package:campus_collaboration_app/features/groups/domain/entities/group_entity.dart';

void main() {
  group('AuthState', () {
    test('AuthLoading is initial state', () {
      final state = AuthLoading();
      expect(state, isA<AuthLoading>());
    });

    test('AuthUnauthenticated represents logged out', () {
      final state = AuthUnauthenticated();
      expect(state, isA<AuthUnauthenticated>());
    });

    test('AuthAuthenticated holds user', () {
      final user = UserEntity(
        id: '1',
        fullName: 'Ruth Tewodros',
        email: 'ruth@aau.edu.et',
        bio: '3rd year SE',
        createdAt: DateTime.now(),
      );
      final state = AuthAuthenticated(user);
      expect(state.user.fullName, 'Ruth Tewodros');
      expect(state.user.email, 'ruth@aau.edu.et');
    });

    test('AuthError holds message', () {
      final state = AuthError('Invalid credentials');
      expect(state.message, 'Invalid credentials');
    });

    test('AuthOperationLoading is distinct from AuthLoading', () {
      expect(AuthOperationLoading(), isA<AuthState>());
      expect(AuthOperationLoading(), isNot(isA<AuthLoading>()));
    });
  });

  group('SkillsState', () {
    final mockSkill = SkillEntity(
      id: 's1',
      title: 'Java Tutoring',
      category: 'Programming',
      description: 'Help with OOP',
      ownerId: 'u1',
      ownerName: 'Ruth',
      ownerYear: '3rd year',
      availability: 'Tuesdays',
      prerequisites: 'None',
      createdAt: DateTime.now(),
    );

    test('SkillsLoading is initial state', () {
      expect(SkillsLoading(), isA<SkillsState>());
    });

    test('SkillsLoaded holds list of skills', () {
      final state = SkillsLoaded([mockSkill]);
      expect(state.skills.length, 1);
      expect(state.skills.first.title, 'Java Tutoring');
    });

    test('SkillsLoaded with empty list', () {
      final state = SkillsLoaded([]);
      expect(state.skills, isEmpty);
    });

    test('SkillsError holds message', () {
      final state = SkillsError('Failed to load skills. Please try again.');
      expect(state.message, contains('Failed'));
    });

    test('SkillsOperationLoading holds previous skills', () {
      final state = SkillsOperationLoading([mockSkill]);
      expect(state.previousSkills.length, 1);
    });
  });

  group('GroupsState', () {
    final mockGroup = GroupEntity(
      id: 'g1',
      name: 'Data Structures Study',
      topic: 'Computer Science',
      description: 'Weekly sessions',
      creatorId: 'u1',
      memberCount: 1,
      memberIds: ['u1'],
      createdAt: DateTime.now(),
    );

    test('GroupsLoading is initial state', () {
      expect(GroupsLoading(), isA<GroupsState>());
    });

    test('GroupsLoaded holds list of groups', () {
      final state = GroupsLoaded([mockGroup]);
      expect(state.groups.length, 1);
      expect(state.groups.first.name, 'Data Structures Study');
    });

    test('GroupsError holds message', () {
      final state = GroupsError('Failed to load groups. Please try again.');
      expect(state.message, contains('Failed'));
    });

    test('GroupsOperationLoading holds previous groups', () {
      final state = GroupsOperationLoading([mockGroup]);
      expect(state.previousGroups.length, 1);
    });

    test('GroupEntity copyWith updates fields', () {
      final updated = mockGroup.copyWith(memberCount: 3);
      expect(updated.memberCount, 3);
      expect(updated.name, mockGroup.name);
    });
  });

  group('UserEntity', () {
    test('creates user with correct fields', () {
      final user = UserEntity(
        id: 'u1',
        fullName: 'Test User',
        email: 'test@aau.edu.et',
        bio: 'SE student',
        createdAt: DateTime.now(),
      );
      expect(user.id, 'u1');
      expect(user.bio, 'SE student');
    });

    test('copyWith updates fullName', () {
      final user = UserEntity(
        id: 'u1',
        fullName: 'Ruth',
        email: 'ruth@aau.edu.et',
        createdAt: DateTime.now(),
      );
      final updated = user.copyWith(fullName: 'Ruth Tewodros');
      expect(updated.fullName, 'Ruth Tewodros');
      expect(updated.id, 'u1');
    });
  });
}
