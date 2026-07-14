import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:project/core/network/api_service.dart';
import 'package:project/core/error/failure.dart';
import 'package:project/core/error/failure_type.dart';
import 'package:project/core/error/dio_mapper.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ApiService _apiService;

  MovieRepositoryImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovies({
    MovieStatus status = MovieStatus.nowShowing,
  }) async {
    try {
      String queryParams = '';
      if (status == MovieStatus.nowShowing) {
        queryParams = '?status=now_showing';
      } else if (status == MovieStatus.comingSoon) {
        queryParams = '?status=coming_soon';
      }

      final response = await _apiService.get('/movies$queryParams');

      if (response.data != null && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        final List<MovieModel> models = data
            .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return Right(models.map((model) => model.toEntity()).toList());
      }
      return const Right([]);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(
        Failure(
          type: FailureType.unknown,
          message: 'An unexpected error occurred.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query) async {
    try {
      final response = await _apiService.get('/movies/search?q=$query');

      if (response.data != null && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        final List<MovieModel> models = data
            .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return Right(models.map((model) => model.toEntity()).toList());
      }
      return const Right([]);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(
        Failure(
          type: FailureType.unknown,
          message: 'An unexpected error occurred.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, MovieEntity>> getMovieById(String id) async {
    try {
      final response = await _apiService.get('/movies/$id');

      if (response.data != null && response.data['data'] != null) {
        final data = response.data['data']['movie'];
        if (data != null) {
          final model = MovieModel.fromJson(data as Map<String, dynamic>);
          return Right(model.toEntity());
        }
      }
      return const Left(
        Failure(
          type: FailureType.unknown,
          message: 'Movie not found.',
        ),
      );
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(
        Failure(
          type: FailureType.unknown,
          message: 'An unexpected error occurred.',
        ),
      );
    }
  }
}
