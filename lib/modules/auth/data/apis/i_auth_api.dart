import 'package:dio/dio.dart';
import '../../model/login_request.dart';
import '../../model/register_request.dart';

abstract class IAuthApi {
  Future<Response> register(RegisterRequest request);

  Future<Response> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Response> resendOtp(String email);

  Future<Response> login(LoginRequest request);

  Future<Response> forgotPassword(String email);

  Future<Response> resetPassword({
    required String email,
    required String otp,
    required String password,
  });

  Future<Response> logout();
}