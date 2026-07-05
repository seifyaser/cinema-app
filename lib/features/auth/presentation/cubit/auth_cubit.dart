import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await authRepository.login(email: email, password: password);
    result.fold(
      (failure) => emit(AuthFailure(type: failure.type, message: failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    result.fold(
      (failure) => emit(AuthFailure(type: failure.type, message: failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
