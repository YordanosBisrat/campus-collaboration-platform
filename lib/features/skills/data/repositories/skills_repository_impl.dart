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
    try {
      final fromRemote = await remote.fetchAllSkills();
      await local.cacheSkills(fromRemote);
      return fromRemote;
    } catch (_) {
      return local.getAllSkills();
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

    final created = await remote.createSkill(skill);
    await local.insertSkill(created);
    return created;
  }

  // ── Update ────────────────────────────────────────────────────────────────

  @override
  Future<SkillEntity> updateSkill(SkillEntity skill) async {
    final model = SkillModel.fromEntity(skill);
    final updated = await remote.updateSkill(model);
    await local.updateSkill(updated);
    return updated;
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  @override
  Future<void> deleteSkill(String id) async {
    await remote.deleteSkill(id);
    await local.deleteSkill(id);
  }

  // ── Request ───────────────────────────────────────────────────────────────

  @override
  Future<void> requestSkill({
    required String skillId,
    required String skillTitle,
    required String requesterId,
    required String requesterName,
  }) async {
    await remote.requestSkill(skillId: skillId, requesterId: requesterId);
    await local.insertSkillRequest(
      id: _uuid.v4(),
      skillId: skillId,
      skillTitle: skillTitle,
      requesterId: requesterId,
      requesterName: requesterName,
    );
  }

  @override
  Future<bool> hasRequested(String skillId, String requesterId) {
    return local.hasRequested(skillId, requesterId);
  }
}
