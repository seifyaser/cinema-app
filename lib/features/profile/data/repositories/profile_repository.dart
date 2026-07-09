import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/core/error/dio_mapper.dart';
import 'package:project/core/error/failure.dart';
import 'package:project/core/error/failure_type.dart';

import '../models/profile_model.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepository({required this.remoteDataSource});

  Future<Either<Failure, ProfileModel>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(Failure(type: FailureType.serverError, message: e.toString()));
    }
  }
}
