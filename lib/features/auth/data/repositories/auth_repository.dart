import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/error/dio_mapper.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_type.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/user_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, UserModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
}

class AuthRepository implements AuthRepo {
  final ApiService _apiService;
  final TokenStorage _tokenStorage;

  AuthRepository(this._apiService, this._tokenStorage);

  @override
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        'auth/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data['data'];
      final userJson = data['user'];
      final token = response.data['data']['token'];
      if (token != null) {
        await _tokenStorage.saveToken(token as String);
      }
      return Right(UserModel.fromJson(userJson as Map<String, dynamic>));
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
  Future<Either<Failure, UserModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        'auth/register',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      final data = response.data['data'];
      final userJson = data['user'];
      final token = response.data['data']['token'];
      if (token != null) {
        await _tokenStorage.saveToken(token as String);
      }
      return Right(UserModel.fromJson(userJson as Map<String, dynamic>));
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
