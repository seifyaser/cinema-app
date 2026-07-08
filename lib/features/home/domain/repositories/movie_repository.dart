import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/movie_entity.dart';

enum MovieStatus { nowShowing, comingSoon }

abstract class MovieRepository {
  Future<Either<Failure, List<MovieEntity>>> getMovies({
    MovieStatus status = MovieStatus.nowShowing,
  });
}
