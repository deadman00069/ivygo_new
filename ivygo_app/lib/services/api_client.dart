import 'package:dio/dio.dart';

import '../core/config/env/env.dart';

/// Application-level constant for the API base URL.
const String kBaseUrl = Env.appBaseUrl;

/// A typed exception thrown when an API call fails.
class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Singleton [Dio] instance pre-configured with the base URL and timeouts.
///
/// All API calls throughout the app should use [apiClient] so that
/// interceptors (logging, auth headers, etc.) apply uniformly.
final Dio apiClient = _buildDio();

Dio _buildDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Interceptor: convert DioException → ApiException for cleaner error handling.
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) {
        final response = e.response;
        String message;

        if (response != null) {
          // Try to extract a meaningful message from the response body.
          final data = response.data;
          if (data is Map<String, dynamic>) {
            message = (data['message'] as String?) ??
                (data['error'] as String?) ??
                'An error occurred (${response.statusCode})';
          } else {
            message = 'An error occurred (${response.statusCode})';
          }
        } else {
          message = switch (e.type) {
            DioExceptionType.connectionTimeout => 'Connection timed out.',
            DioExceptionType.receiveTimeout =>
              'Server took too long to respond.',
            DioExceptionType.connectionError => 'No internet connection.',
            _ => e.message ?? 'An unexpected error occurred.',
          };
        }

        handler.reject(
          DioException(
            requestOptions: e.requestOptions,
            error: ApiException(
              message: message,
              statusCode: response?.statusCode,
            ),
          ),
        );
      },
    ),
  );

  return dio;
}
