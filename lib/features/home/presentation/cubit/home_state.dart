import 'package:project/core/error/failure_type.dart';
import '../../domain/entities/movie_entity.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<MovieEntity> nowPlayingMovies;
  final List<MovieEntity> comingSoonMovies;

  const HomeLoaded({
    required this.nowPlayingMovies,
    required this.comingSoonMovies,
  });
}

class HomeError extends HomeState {
  final FailureType type;
  final String message;

  const HomeError({required this.type, required this.message});
}
