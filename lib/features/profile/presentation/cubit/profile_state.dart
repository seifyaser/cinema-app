import 'package:project/core/error/failure_type.dart';
import '../../data/models/profile_model.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;

  const ProfileLoaded({required this.profile});
}

class ProfileError extends ProfileState {
  final FailureType type;
  final String message;

  const ProfileError({required this.type, required this.message});
}
