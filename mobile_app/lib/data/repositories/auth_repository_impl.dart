import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:mobile_app/core/constants/app_constants.dart';
import 'package:mobile_app/domain/repositories/auth_repository.dart';
import 'package:mobile_app/data/models/user_model.dart';
import 'package:mobile_app/data/datasources/api_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(this._apiClient, this._storage);

  @override
  Future<User?> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final userData = response.data['user'];
        final user = User.fromJson(userData);

        await _storage.write(key: AppConstants.tokenKey, value: token);
        await _storage.write(key: AppConstants.userKey, value: jsonEncode(user.toJson()));

        return user;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.userKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    final userData = await _storage.read(key: AppConstants.userKey);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  @override
  Future<void> registerRequest(Map<String, dynamic> data) async {
    await _apiClient.post('/auth/register-request', data: data);
  }

  @override
  Future<void> verifyEmail(String email, String code) async {
    await _apiClient.post('/auth/verify-email', data: {'email': email, 'code': code});
  }
}
