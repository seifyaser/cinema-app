import '../models/user_model.dart';

class AuthRepository {
  // TODO: Inject network client (e.g. Dio) here
  AuthRepository();

  Future<UserModel> login({required String email, required String password}) async {
    // Placeholder implementation
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(id: '1', email: email, name: 'Test User');
  }

  Future<UserModel> register({required String name, required String email, required String password}) async {
    // Placeholder implementation
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(id: '2', email: email, name: name);
  }
}
