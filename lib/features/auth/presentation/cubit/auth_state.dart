import 'package:flutter/foundation.dart';
import 'package:project/core/error/failure_type.dart';
import '../../data/models/user_model.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final FailureType type;
  final String message;

  AuthFailure({required this.type, required this.message});
}
