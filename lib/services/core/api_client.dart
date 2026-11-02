/*
@Author - yehenSamarasinghe
@Date - 2026/09/01
*/

import 'package:dio/dio.dart';
import 'token_storage.dart';

class ApiClient {
  /// Set once in main.dart. Called when the API says the token is invalid.
  static void Function()? onUnauthorized;

    // TEMPORARY: until the backend reads the Bearer token on submit-quiz and
  // /contents, progress only saves when X-Student-Token (the student's uuid
  // from GET /me) is sent. Remove once the backend confirms Bearer works.
  static bool _needsStudentToken(String path) =>
      path.endsWith('/submit-quiz') || path.endsWith('/contents');

  static Future<String?> _studentUuid(String bearer) async {
    final cached = await TokenStorage.getStudentUuid();
    if (cached != null && cached.isNotEmpty) return cached;

    try {
      // A plain Dio with no interceptors, so this can't loop back here.
      final response = await Dio(
        BaseOptions(
          baseUrl: dio.options.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $bearer',
          },
        ),
      ).get('/me');

      final uuid = (response.data['profile']['uuid'] ?? '') as String;
      if (uuid.isEmpty) return null;

      await TokenStorage.saveStudentUuid(uuid);
      return uuid;
    } catch (_) {
      return null; // send the request without the header
    }
  }

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.aixx.com.sg/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';

            if (_needsStudentToken(options.path)) {
              final uuid = await _studentUuid(token);
              if (uuid != null) options.headers['X-Student-Token'] = uuid;
            }
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          final isAuthCall = error.requestOptions.path.startsWith('/auth/');

          if (error.response?.statusCode == 401 && !isAuthCall) {
            await TokenStorage.clearToken();
            onUnauthorized?.call();
          }

          handler.next(error);
        },
      ),
    );
}