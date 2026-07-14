import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/core/error/dio_mapper.dart';
import 'package:project/core/error/failure.dart';
import 'package:project/core/error/failure_type.dart';

import 'package:project/core/storage/token_storage.dart';
import 'package:project/features/auth/data/models/user_model.dart';
import '../models/profile_model.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  ProfileRepository({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  Future<Either<Failure, ProfileModel>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(
        Failure(type: FailureType.serverError, message: e.toString()),
      );
    }
  }

  Future<Either<Failure, LogoutResponse>> logout() async {
    try {
      try {
        await remoteDataSource.logout();
      } catch (e) {
        // Ignore remote logout errors to ensure local token is still deleted
      }
      await tokenStorage.deleteToken();
      return Right(LogoutResponse(success: true, message: 'Logout successful'));
    } catch (e) {
      return Left(Failure(type: FailureType.unknown, message: e.toString()));
    }
  }
}
