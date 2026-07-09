import 'package:project/core/network/api_service.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSourceImpl({required this.apiService});

  @override
  Future<ProfileModel> getProfile() async {
    final response = await apiService.get('/auth/me');
    final data = response.data['data']['user'];
    return ProfileModel.fromJson(data);
  }
}
