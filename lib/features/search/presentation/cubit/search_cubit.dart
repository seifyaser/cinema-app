import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/features/home/domain/repositories/movie_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final MovieRepository _movieRepository;

  SearchCubit({required MovieRepository movieRepository})
      : _movieRepository = movieRepository,
        super(SearchInitial());

  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    final result = await _movieRepository.searchMovies(query);
    result.fold(
      (failure) => emit(SearchError(type: failure.type, message: failure.message)),
      (movies) => emit(SearchLoaded(movies: movies)),
    );
  }

  void resetSearch() {
    emit(SearchInitial());
  }
}
