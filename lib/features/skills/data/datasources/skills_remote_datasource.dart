import 'package:uuid/uuid.dart';
import '../models/skill_model.dart';

/// Mock remote datasource — mirrors GroupRemoteDatasource pattern.
/// Replace method bodies with real HTTP calls when backend is ready.
class SkillsRemoteDatasource {
  final _uuid = const Uuid();

  Future<void> get _delay => Future.delayed(const Duration(milliseconds: 350));

  // In-memory store simulating a remote database
  final List<SkillModel> _skills = [];

  Future<List<SkillModel>> fetchAllSkills() async {
    await _delay;
    return List.unmodifiable(_skills);
  }

  Future<SkillModel> createSkill(SkillModel skill) async {
    await _delay;
    _skills.add(skill);
    return skill;
  }

  Future<SkillModel> updateSkill(SkillModel skill) async {
    await _delay;
    final i = _skills.indexWhere((s) => s.id == skill.id);
    if (i != -1) _skills[i] = skill;
    return skill;
  }

  Future<void> deleteSkill(String id) async {
    await _delay;
    _skills.removeWhere((s) => s.id == id);
  }

  Future<void> requestSkill({
    required String skillId,
    required String requesterId,
  }) async {
    await _delay;
    // Mock — replace with: POST /api/skills/:id/requests
  }

  String generateId() => _uuid.v4();
}
