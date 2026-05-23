import 'package:uuid/uuid.dart';
import '../../domain/entities/skill_entity.dart';
import '../../domain/repositories/skills_repository.dart';
import '../datasources/skills_local_datasource.dart';
import '../datasources/skills_remote_datasource.dart';
import '../models/skill_model.dart';

class SkillsRepositoryImpl implements SkillsRepository {
  final SkillsLocalDatasource local;
  final SkillsRemoteDatasource remote;
  static const _uuid = Uuid();

  const SkillsRepositoryImpl({required this.local, required this.remote});

  // ── Read ──────────────────────────────────────────────────────────────────

  @override
  Future<List<SkillEntity>> getSkills() async {
    final cached = await local.getAllSkills();
    if (cached.isNotEmpty) return cached;
    try {
      final fromRemote = await remote.fetchAllSkills();
      if (fromRemote.isNotEmpty) await local.cacheSkills(fromRemote);
      return fromRemote;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<SkillEntity>> getMySkills(String userId) async {
    return local.getSkillsByOwner(userId);
  }

  @override
  Future<SkillEntity?> getSkillById(String id) async {
    return local.getSkillById(id);
  }

  // ── Create ────────────────────────────────────────────────────────────────

  @override
  Future<SkillEntity> createSkill({
    required String title,
    required String category,
    required String description,
    required String ownerId,
    required String ownerName,
    required String ownerYear,
    required String availability,
    required String prerequisites,
  }) async {
    final skill = SkillModel.fromEntity(
      SkillEntity(
        id: _uuid.v4(),
        title: title,
        category: category,
        description: description,
        ownerId: ownerId,
        ownerName: ownerName,
        ownerYear: ownerYear,
        availability: availability,
        prerequisites: prerequisites,
        createdAt: DateTime.now(),
      ),
    );

    // Save locally first (offline-first)
    await local.insertSkill(skill);

    // Fire-and-forget to mock remote
    try {
      await remote.createSkill(skill);
    } catch (_) {}

    return skill;
  }

  // ── Update ────────────────────────────────────────────────────────────────

  @override
  Future<SkillEntity> updateSkill(SkillEntity skill) async {
    final model = SkillModel.fromEntity(skill);
    await local.updateSkill(model);
    try {
      await remote.updateSkill(model);
    } catch (_) {}
    return skill;
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  @override
  Future<void> deleteSkill(String id) async {
    await local.deleteSkill(id);
    try {
      await remote.deleteSkill(id);
    } catch (_) {}
  }

  // ── Request ───────────────────────────────────────────────────────────────

  @override
  Future<void> requestSkill({
    required String skillId,
    required String skillTitle,
    required String requesterId,
    required String requesterName,
  }) async {
    final already = await local.hasRequested(skillId, requesterId);
    if (already) throw Exception('You have already requested this skill.');

    await local.insertSkillRequest(
      id: _uuid.v4(),
      skillId: skillId,
      skillTitle: skillTitle,
      requesterId: requesterId,
      requesterName: requesterName,
    );

    try {
      await remote.requestSkill(skillId: skillId, requesterId: requesterId);
    } catch (_) {}
  }

  @override
  Future<bool> hasRequested(String skillId, String requesterId) {
    return local.hasRequested(skillId, requesterId);
  }
}
