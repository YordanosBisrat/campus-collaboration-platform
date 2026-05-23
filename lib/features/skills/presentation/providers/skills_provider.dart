import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/skills_local_datasource.dart';
import '../../data/datasources/skills_remote_datasource.dart';
import '../../data/repositories/skills_repository_impl.dart';
import '../../domain/entities/skill_entity.dart';
import '../../domain/repositories/skills_repository.dart';

// ── State (mirrors GroupsState pattern) ──────────────────────────────────────

abstract class SkillsState {}

class SkillsLoading extends SkillsState {}

class SkillsLoaded extends SkillsState {
  final List<SkillEntity> skills;
  SkillsLoaded(this.skills);
}

class SkillsError extends SkillsState {
  final String message;
  SkillsError(this.message);
}

class SkillsOperationLoading extends SkillsState {
  final List<SkillEntity> previousSkills;
  SkillsOperationLoading(this.previousSkills);
}

// ── Infrastructure providers ──────────────────────────────────────────────────

final _skillsLocalDatasourceProvider = Provider<SkillsLocalDatasource>(
  (ref) => SkillsLocalDatasource(),
);

final _skillsRemoteDatasourceProvider = Provider<SkillsRemoteDatasource>(
  (ref) => SkillsRemoteDatasource(),
);

final skillsRepositoryProvider = Provider<SkillsRepository>((ref) {
  return SkillsRepositoryImpl(
    local: ref.watch(_skillsLocalDatasourceProvider),
    remote: ref.watch(_skillsRemoteDatasourceProvider),
  );
});

// ── Main Notifier ─────────────────────────────────────────────────────────────

class SkillsNotifier extends Notifier<SkillsState> {
  late final SkillsRepository _repo;

  @override
  SkillsState build() {
    _repo = ref.read(skillsRepositoryProvider);
    Future.microtask(() => _load());
    return SkillsLoading();
  }

  List<SkillEntity> get _current {
    if (state is SkillsLoaded) return (state as SkillsLoaded).skills;
    if (state is SkillsOperationLoading) {
      return (state as SkillsOperationLoading).previousSkills;
    }
    return [];
  }

  Future<void> _load() async {
    state = SkillsLoading();
    try {
      final skills = await _repo.getSkills();
      state = SkillsLoaded(skills);
    } catch (_) {
      state = SkillsError('Failed to load skills. Please try again.');
    }
  }

  Future<void> refresh() => _load();

  // ── Create ────────────────────────────────────────────────────────────────

  Future<String?> createSkill({
    required String title,
    required String category,
    required String description,
    required String availability,
    required String prerequisites,
  }) async {
    final prev = _current;
    state = SkillsOperationLoading(prev);
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        state = SkillsLoaded(prev);
        return 'You must be logged in.';
      }
      final skill = await _repo.createSkill(
        title: title,
        category: category,
        description: description,
        ownerId: user.id,
        ownerName: user.fullName,
        ownerYear: user.bio,
        availability: availability,
        prerequisites: prerequisites,
      );
      state = SkillsLoaded([skill, ...prev]);
      ref.invalidate(mySkillsProvider);
      return null;
    } catch (e) {
      state = SkillsLoaded(prev);
      return e.toString();
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<String?> updateSkill(SkillEntity skill) async {
    final prev = _current;
    state = SkillsOperationLoading(prev);
    try {
      final updated = await _repo.updateSkill(skill);
      state = SkillsLoaded(
        prev.map((s) => s.id == updated.id ? updated : s).toList(),
      );
      ref.invalidate(mySkillsProvider);
      return null;
    } catch (e) {
      state = SkillsLoaded(prev);
      return e.toString();
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<String?> deleteSkill(String id) async {
    final prev = _current;
    state = SkillsOperationLoading(prev);
    try {
      await _repo.deleteSkill(id);
      state = SkillsLoaded(prev.where((s) => s.id != id).toList());
      ref.invalidate(mySkillsProvider);
      return null;
    } catch (e) {
      state = SkillsLoaded(prev);
      return e.toString();
    }
  }

  // ── Request ───────────────────────────────────────────────────────────────

  Future<String?> requestSkill({
    required String skillId,
    required String skillTitle,
  }) async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return 'You must be logged in.';
      await _repo.requestSkill(
        skillId: skillId,
        skillTitle: skillTitle,
        requesterId: user.id,
        requesterName: user.fullName,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

final skillsProvider = NotifierProvider<SkillsNotifier, SkillsState>(
  SkillsNotifier.new,
);

final isSkillOperationLoadingProvider = Provider<bool>((ref) {
  return ref.watch(skillsProvider) is SkillsOperationLoading;
});

// ── Single skill by id ────────────────────────────────────────────────────────

final singleSkillProvider = Provider.family<SkillEntity?, String>((ref, id) {
  final state = ref.watch(skillsProvider);
  List<SkillEntity> skills;
  if (state is SkillsLoaded) {
    skills = state.skills;
  } else if (state is SkillsOperationLoading) {
    skills = state.previousSkills;
  } else {
    skills = [];
  }
  try {
    return skills.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
});

// ── My Skills notifier ────────────────────────────────────────────────────────

abstract class MySkillsState {}

class MySkillsLoading extends MySkillsState {}

class MySkillsLoaded extends MySkillsState {
  final List<SkillEntity> skills;
  MySkillsLoaded(this.skills);
}

class MySkillsError extends MySkillsState {
  final String message;
  MySkillsError(this.message);
}

class MySkillsNotifier extends Notifier<MySkillsState> {
  late final SkillsRepository _repo;

  @override
  MySkillsState build() {
    _repo = ref.read(skillsRepositoryProvider);
    final user = ref.watch(currentUserProvider);
    if (user != null) Future.microtask(() => loadMySkills(user.id));
    return MySkillsLoading();
  }

  Future<void> loadMySkills(String userId) async {
    state = MySkillsLoading();
    try {
      final skills = await _repo.getMySkills(userId);
      state = MySkillsLoaded(skills);
    } catch (_) {
      state = MySkillsError('Failed to load your skills.');
    }
  }
}

final mySkillsProvider = NotifierProvider<MySkillsNotifier, MySkillsState>(
  MySkillsNotifier.new,
);
