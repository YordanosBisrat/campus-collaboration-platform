import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity?> getProfile(String userId);
  Future<void> updateProfile(ProfileEntity profile);
  Future<void> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  );
}
