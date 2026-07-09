import 'package:get_it/get_it.dart';
import 'package:project/core/network/api_service.dart';
import 'package:project/core/storage/token_storage.dart';
import 'package:project/features/auth/data/repositories/auth_repository.dart';
import 'package:project/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project/features/home/data/repositories/movie_repository_impl.dart';
import 'package:project/features/home/domain/repositories/movie_repository.dart';
import 'package:project/features/home/presentation/cubit/home_cubit.dart';

import 'package:project/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:project/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:project/features/booking/presentation/cubit/booking_cubit.dart';

import 'package:project/features/tickets/data/datasources/ticket_remote_data_source.dart';
import 'package:project/features/tickets/data/repositories/ticket_repository_impl.dart';
import 'package:project/features/tickets/domain/repositories/ticket_repository.dart';
import 'package:project/features/tickets/domain/usecases/get_my_tickets.dart';
import 'package:project/features/tickets/presentation/cubit/ticket_cubit.dart';

import 'package:project/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:project/features/profile/data/repositories/profile_repository.dart';
import 'package:project/features/profile/presentation/cubit/profile_cubit.dart';

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
  
  // Booking Feature
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(apiService: sl()),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl()),
  );

  // Cubits
  sl.registerFactory<AuthCubit>(() => AuthCubit(authRepository: sl()));
  sl.registerFactory<HomeCubit>(() => HomeCubit(movieRepository: sl()));
  sl.registerFactoryParam<BookingCubit, String, dynamic>(
    (movieId, _) => BookingCubit(bookingRepository: sl(), movieId: movieId),
  );

  // ========== Tickets Feature ==========
  sl.registerLazySingleton<TicketRemoteDataSource>(
    () => TicketRemoteDataSourceImpl(apiService: sl()),
  );

  sl.registerLazySingleton<TicketRepository>(
    () => TicketRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetMyTickets(sl()));

  sl.registerFactory(() => TicketCubit(getMyTickets: sl()));

  // ========== Profile Feature ==========
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiService: sl()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(remoteDataSource: sl()),
  );

  sl.registerFactory(() => ProfileCubit(repository: sl()));
}
