import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ivygo_app/models/auth_models.dart';
import 'package:ivygo_app/services/api_client.dart';

/// Key used to store the auth token in secure storage.
const _kTokenKey = 'auth_token';

/// Handles all authentication-related API calls and secure token persistence.
class AuthService {
  AuthService({
    Dio? dio,
    FlutterSecureStorage? storage,
  })  : _dio = dio ?? apiClient,
        _storage = storage ?? const FlutterSecureStorage();

  final Dio _dio;
  final FlutterSecureStorage _storage;

  /// Calls `POST /login` and persists the returned token.
  ///
  /// Throws [ApiException] on HTTP errors or network failures.
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/login',
        data: LoginRequest(email: email, password: password).toJson(),
      );

      final data = response.data;
      if (data == null) {
        throw const ApiException(message: 'Empty response from server.');
      }

      final loginResponse = LoginResponse.fromJson(data);
      await _storage.write(key: _kTokenKey, value: loginResponse.token);
      return loginResponse;
    } on DioException catch (e) {
      // Re-throw as ApiException (already converted by the interceptor).
      final error = e.error;
      if (error is ApiException) rethrow;
      throw ApiException(message: e.message ?? 'Login failed.');
    }
  }

  /// Returns the stored auth token, or `null` if none exists.
  Future<String?> getToken() => _storage.read(key: _kTokenKey);

  /// Deletes the stored auth token (logout).
  Future<void> logout() => _storage.delete(key: _kTokenKey);
}

/// Global singleton instance of [AuthService].
final authService = AuthService();
