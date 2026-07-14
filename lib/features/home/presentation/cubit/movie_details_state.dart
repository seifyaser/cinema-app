import 'package:project/core/error/failure_type.dart';
import 'package:project/features/home/domain/entities/movie_entity.dart';

abstract class MovieDetailsState {}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieEntity movie;

  MovieDetailsLoaded({required this.movie});
}

class MovieDetailsError extends MovieDetailsState {
  final FailureType type;
  final String message;

  MovieDetailsError({required this.type, required this.message});
}
