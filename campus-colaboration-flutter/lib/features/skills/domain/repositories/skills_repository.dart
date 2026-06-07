import '../entities/skill_entity.dart';

abstract class SkillsRepository {
  Future<List<SkillEntity>> getSkills();
  Future<List<SkillEntity>> getMySkills(String userId);
  Future<SkillEntity?> getSkillById(String id);

  Future<SkillEntity> createSkill({
    required String title,
    required String category,
    required String description,
    required String ownerId,
    required String ownerName,
    required String ownerYear,
    required String availability,
    required String prerequisites,
  });

  Future<SkillEntity> updateSkill(SkillEntity skill);
  Future<void> deleteSkill(String id);

  Future<void> requestSkill({
    required String skillId,
    required String skillTitle,
    required String requesterId,
    required String requesterName,
  });

  Future<bool> hasRequested(String skillId, String requesterId);
}
