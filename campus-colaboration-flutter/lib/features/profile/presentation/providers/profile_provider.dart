import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

// ── Datasource Providers ──────────────────────────────────
final profileLocalDatasourceProvider =
    Provider<ProfileLocalDatasource>((_) => ProfileLocalDatasource());

final profileRemoteDatasourceProvider =
    Provider<ProfileRemoteDatasource>((_) => ProfileRemoteDatasource());

// ── Repository Provider ───────────────────────────────────
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(
    local: ref.watch(profileLocalDatasourceProvider),
    remote: ref.watch(profileRemoteDatasourceProvider),
  ),
);

// ── Profile State ─────────────────────────────────────────
sealed class ProfileState {}
final class ProfileInitial extends ProfileState {}
final class ProfileLoading extends ProfileState {}
final class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  ProfileLoaded(this.profile);
}
final class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
final class ProfileUpdating extends ProfileState {
  final ProfileEntity profile;
  ProfileUpdating(this.profile);
}
final class ProfileUpdated extends ProfileState {
  final ProfileEntity profile;
  ProfileUpdated(this.profile);
}

// ── Profile Notifier ──────────────────────────────────────
class ProfileNotifier extends Notifier<ProfileState> {
  late final ProfileRepository _repository;

  @override
  ProfileState build() {
    _repository = ref.watch(profileRepositoryProvider);
    loadProfile();
    return ProfileInitial();
  }

  Future<void> loadProfile() async {
    state = ProfileLoading();
    try {
      final authState = ref.read(authProvider);
      if (authState is! AuthAuthenticated) {
        state = ProfileError('Not authenticated');
        return;
      }
      final profile = await _repository.getProfile(authState.user.id);
      if (profile != null) {
        state = ProfileLoaded(profile);
      } else {
        state = ProfileLoaded(
          ProfileEntity(
            id: authState.user.id,
            fullName: authState.user.fullName,
            email: authState.user.email,
            bio: authState.user.bio,
            createdAt: authState.user.createdAt,
          ),
        );
      }
    } catch (e) {
      state = ProfileError(e.toString());
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String bio,
  }) async {
    final current = state;
    if (current is! ProfileLoaded) return;
    state = ProfileUpdating(current.profile);
    try {
      final updated = current.profile.copyWith(
        fullName: fullName,
        email: email,
        bio: bio,
      );
      await _repository.updateProfile(updated);
      state = ProfileUpdated(updated);
    } catch (e) {
      state = ProfileError(e.toString());
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final current = state;
    if (current is! ProfileLoaded) return false;
    try {
      await _repository.changePassword(
        current.profile.id,
        oldPassword,
        newPassword,
      );
      return true;
    } catch (e) {
      state = ProfileError(e.toString());
      return false;
    }
  }
}

// ── Profile Provider ──────────────────────────────────────
final profileNotifierProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);
