import 'package:get_it/get_it.dart';
import 'package:project/core/network/api_service.dart';
import 'package:project/features/auth/data/repositories/auth_repository.dart';
import 'package:project/features/auth/presentation/cubit/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl()));

  // Cubits
  sl.registerFactory<AuthCubit>(() => AuthCubit(authRepository: sl()));
}
