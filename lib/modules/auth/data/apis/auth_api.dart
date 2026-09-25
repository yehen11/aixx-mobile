/*
@Author - yehenSamarasinghe
@Date - 2026/09/01
*/

import 'package:dio/dio.dart';

import '../../../../services/core/api_client.dart';
import '../../model/login_request.dart';
import '../../model/register_request.dart';
import 'i_auth_api.dart';

class AuthApi implements IAuthApi {
  @override
  Future<Response> register(RegisterRequest request) {
    return ApiClient.dio.post(
      '/auth/register',
      data: request.toJson(),
    );
  }

  @override
  Future<Response> verifyOtp({
    required String email,
    required String otp,
  }) {
    return ApiClient.dio.post(
      '/auth/verify-otp',
      data: {
        'email': email,
        'otp': otp,
      },
    );
  }

  @override
  Future<Response> resendOtp(String email) {
    return ApiClient.dio.post(
      '/auth/resend-otp',
      data: {
        'email': email,
      },
    );
  }

  @override
  Future<Response> login(LoginRequest request) {
    return ApiClient.dio.post(
      '/auth/login',
      data: request.toJson(),
    );
  }

  @override
  Future<Response> forgotPassword(String email) {
    return ApiClient.dio.post(
      '/auth/forgot-password',
      data: {
        'email': email,
      },
    );
  }

  @override
  Future<Response> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) {
    return ApiClient.dio.post(
      '/auth/reset-password',
      data: {
        'email': email,
        'otp': otp,
        'password': password,
      },
    );
  }

  @override
  Future<Response> logout() {
    return ApiClient.dio.post('/auth/logout');
  }
}