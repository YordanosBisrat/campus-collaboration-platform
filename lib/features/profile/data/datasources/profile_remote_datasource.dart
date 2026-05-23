import '../models/profile_model.dart';

class ProfileRemoteDatasource {
  Future<ProfileModel?> getProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return null;
  }

  Future<void> updateProfile(ProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
