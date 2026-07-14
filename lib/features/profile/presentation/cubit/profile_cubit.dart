import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/profile_repository.dart';
import 'package:project/core/notifications/data/repositories/notification_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  final NotificationRepository _notificationRepository;

  ProfileCubit({
    required ProfileRepository repository,
    required NotificationRepository notificationRepository,
  })
    : _repository = repository,
      _notificationRepository = notificationRepository,
      super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    final result = await _repository.getProfile();
    result.fold(
      (failure) =>
          emit(ProfileError(type: failure.type, message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> logoutUser() async {
    emit(ProfileLoading());
    await _notificationRepository.unregisterDeviceToken();
    final result = await _repository.logout();
    result.fold(
      (failure) =>
          emit(ProfileError(type: failure.type, message: failure.message)),
      (_) => emit(ProfileLoggedOut()),
    );
  }
}
