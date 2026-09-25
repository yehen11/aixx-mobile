import 'package:dio/dio.dart';
import '../apis/i_auth_api.dart';
import '../../model/login_request.dart';
import '../../model/register_request.dart';

class AuthRepository {
  final IAuthApi _api;

  AuthRepository(this._api);

  Future<Response> register(RegisterRequest request) {
    return _api.register(request);
  }

  Future<Response> verifyOtp({
    required String email,
    required String otp,
  }) {
    return _api.verifyOtp(
      email: email,
      otp: otp,
    );
  }

  Future<Response> resendOtp(String email) {
    return _api.resendOtp(email);
  }

  Future<Response> login(LoginRequest request) {
    return _api.login(request);
  }

  Future<Response> forgotPassword(String email) {
    return _api.forgotPassword(email);
  }

  Future<Response> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) {
    return _api.resetPassword(
      email: email,
      otp: otp,
      password: password,
    );
  }

  Future<Response> logout() {
    return _api.logout();
  }
}