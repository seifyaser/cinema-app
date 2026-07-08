import 'package:get_it/get_it.dart';
import 'package:project/core/network/api_service.dart';
import 'package:project/core/storage/token_storage.dart';
import 'package:project/features/auth/data/repositories/auth_repository.dart';
import 'package:project/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project/features/home/data/repositories/movie_repository_impl.dart';
import 'package:project/features/home/domain/repositories/movie_repository.dart';

import 'package:project/features/home/presentation/cubit/home_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core — Storage
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage());

  // Core — Network
  sl.registerLazySingleton<ApiService>(() => ApiService(sl()));

  // Repositories — register implementation against abstract interface
  sl.registerLazySingleton<AuthRepo>(() => AuthRepository(sl(), sl()));
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(apiService: sl()),
  );

  // Cubits
  sl.registerFactory<AuthCubit>(() => AuthCubit(authRepository: sl()));
  sl.registerFactory<HomeCubit>(() => HomeCubit(movieRepository: sl()));
}
