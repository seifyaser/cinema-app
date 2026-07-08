import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/core/error/failure_type.dart';
import '../../domain/repositories/movie_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MovieRepository _movieRepository;

  HomeCubit({required MovieRepository movieRepository})
      : _movieRepository = movieRepository,
        super(HomeInitial());

  Future<void> fetchMovies() async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        _movieRepository.getMovies(status: MovieStatus.nowShowing),
        _movieRepository.getMovies(status: MovieStatus.comingSoon),
      ]);

      final nowPlayingEither = results[0];
      final comingSoonEither = results[1];

      nowPlayingEither.fold(
        (failure) => emit(HomeError(type: failure.type, message: failure.message)),
        (nowPlayingMovies) {
          comingSoonEither.fold(
            (failure) => emit(HomeError(type: failure.type, message: failure.message)),
            (comingSoonMovies) {
              emit(HomeLoaded(
                nowPlayingMovies: nowPlayingMovies,
                comingSoonMovies: comingSoonMovies,
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(HomeError(type: FailureType.unknown, message: e.toString()));
    }
  }
}
