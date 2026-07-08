import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/core/error/dio_mapper.dart';
import 'package:project/core/error/failure.dart';
import 'package:project/core/error/failure_type.dart';

import '../../domain/entities/showtime_entity.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/showtime_model.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<String>>> getAvailableDates(String movieId);
  Future<Either<Failure, List<ShowtimeEntity>>> getShowtimes(
    String movieId,
    String date,
  );
}

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepositoryImpl({required BookingRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<String>>> getAvailableDates(
    String movieId,
  ) async {
    try {
      final dates = await _remoteDataSource.getAvailableDates(movieId);
      return Right(dates);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(
        Failure(
          type: FailureType.unknown,
          message: 'An unexpected error occurred while fetching dates.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ShowtimeEntity>>> getShowtimes(
    String movieId,
    String date,
  ) async {
    try {
      final showtimeModels = await _remoteDataSource.getShowtimes(
        movieId,
        date,
      );
      final showtimeEntities = showtimeModels
          .map((model) => model.toEntity())
          .toList();
      return Right(showtimeEntities);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(
        Failure(
          type: FailureType.unknown,
          message: 'An unexpected error occurred while fetching showtimes.',
        ),
      );
    }
  }
}
