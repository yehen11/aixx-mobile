/*
@Author - yehenSamarasinghe
@Date - 2026/09/01
*/

import 'package:dio/dio.dart';
import 'token_storage.dart';

class ApiClient {
  /// Set once in main.dart. Called when the API says the token is invalid.
  static void Function()? onUnauthorized;

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