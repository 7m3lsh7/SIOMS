import 'package:mobile_app/data/models/user_model.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> registerRequest(Map<String, dynamic> data);
  Future<void> verifyEmail(String email, String code);
}
