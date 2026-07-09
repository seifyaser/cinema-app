import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit({required ProfileRepository repository})
      : _repository = repository,
        super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    final result = await _repository.getProfile();
    result.fold(
      (failure) => emit(ProfileError(type: failure.type, message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }
}
