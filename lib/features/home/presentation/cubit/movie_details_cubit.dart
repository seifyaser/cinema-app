import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/core/error/failure_type.dart';
import 'package:project/features/home/domain/entities/movie_entity.dart';
import 'package:project/features/home/domain/repositories/movie_repository.dart';
import 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final MovieRepository _movieRepository;

  MovieDetailsCubit({required MovieRepository movieRepository})
      : _movieRepository = movieRepository,
        super(MovieDetailsInitial());

  /// Used when navigating with a full movie entity
  void setMovie(MovieEntity movie) {
    emit(MovieDetailsLoaded(movie: movie));
  }

  /// Used when deep-linking with only a movie ID
  Future<void> fetchMovieById(String movieId) async {
    emit(MovieDetailsLoading());
    try {
      final result = await _movieRepository.getMovieById(movieId);
      result.fold(
        (failure) => emit(MovieDetailsError(type: failure.type, message: failure.message)),
        (movie) => emit(MovieDetailsLoaded(movie: movie)),
      );
    } catch (e) {
      emit(MovieDetailsError(type: FailureType.unknown, message: e.toString()));
    }
  }
}
