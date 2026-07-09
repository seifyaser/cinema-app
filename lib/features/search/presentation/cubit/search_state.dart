import 'package:project/core/error/failure_type.dart';
import 'package:project/features/home/domain/entities/movie_entity.dart';

abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<MovieEntity> movies;

  const SearchLoaded({required this.movies});
}

class SearchError extends SearchState {
  final FailureType type;
  final String message;

  const SearchError({required this.type, required this.message});
}
