import 'package:dartz/dartz.dart';
import 'package:project/core/error/failure.dart';
import 'package:project/core/error/failure_type.dart';
import 'package:project/core/network/api_service.dart';
import 'package:project/core/storage/token_storage.dart';
import 'package:project/features/auth/data/models/user_model.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<void> logout();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;
  final TokenStorage tokenStorage;
  ProfileRemoteDataSourceImpl({
    required this.apiService,
    required this.tokenStorage,
  });

  @override
  Future<ProfileModel> getProfile() async {
    final response = await apiService.get('/auth/me');
    final data = response.data['data']['user'];
    return ProfileModel.fromJson(data);
  }

  @override
  Future<Either<Failure, LogoutResponse>> logout() async {
    try {
      final response = await apiService.post('auth/logout');

      final result = LogoutResponse.fromJson(response.data);

      if (result.success) {
        await tokenStorage.deleteToken();
        return right(result);
      }

      return left(
        Failure(type: FailureType.unauthorized, message: result.message),
      );
    } on Exception catch (e) {
      return left(Failure(type: FailureType.unknown, message: e.toString()));
    }
  }
}
