import 'package:dio/dio.dart';

import 'i_auth_api.dart';
import '../../model/login_request.dart';
import '../../model/register_request.dart';

class MockAuthApi implements IAuthApi {
  static const String _mockOtp = '123456';
  static const String _mockToken = 'mock_auth_token';

  @override
  Future<Response> register(RegisterRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      requestOptions: RequestOptions(path: '/auth/register'),
      statusCode: 200,
      data: {
        'message': 'Registration successful. OTP sent to your email.',
        'email': request.email,
        'registration_id': 'MOCK-REG-001',
      },
    );
  }

  @override
  Future<Response> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (otp != _mockOtp) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/verify-otp'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/verify-otp'),
          statusCode: 422,
          data: {
            'message': 'Invalid OTP.',
          },
        ),
      );
    }

    return Response(
      requestOptions: RequestOptions(path: '/auth/verify-otp'),
      statusCode: 200,
      data: {
        'message': 'Email verified successfully.',
        'token': _mockToken,
        'student': {
          'id': 1,
          'uuid': 'mock-uuid',
          'registration_id': 'MOCK-REG-001',
          'full_name': 'Test Student',
          'email': email,
          'phone': '+94770000000',
          'country': 'Sri Lanka',
        },
      },
    );
  }

  @override
  Future<Response> resendOtp(String email) async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      requestOptions: RequestOptions(path: '/auth/resend-otp'),
      statusCode: 200,
      data: {
        'message': 'OTP resent successfully.',
      },
    );
  }

  @override
  Future<Response> login(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    if (request.email == 'unverified@test.com') {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 403,
          data: {
            'message': 'Please verify your email address.',
            'requires_verification': true,
            'email': request.email,
          },
        ),
      );
    }

    if (request.email != 'test@aixx.com' ||
        request.password != 'Password123') {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
          data: {
            'message': 'Invalid email or password.',
          },
        ),
      );
    }

    return Response(
      requestOptions: RequestOptions(path: '/auth/login'),
      statusCode: 200,
      data: {
        'token': _mockToken,
        'student': {
          'id': 1,
          'uuid': 'mock-uuid',
          'registration_id': 'MOCK-REG-001',
          'full_name': 'Test Student',
          'email': request.email,
          'phone': '+94770000000',
          'country': 'Sri Lanka',
        },
      },
    );
  }

  @override
  Future<Response> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      requestOptions: RequestOptions(path: '/auth/forgot-password'),
      statusCode: 200,
      data: {
        'message': 'Password reset code sent successfully.',
      },
    );
  }

  @override
  Future<Response> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (otp != _mockOtp) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/reset-password'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/reset-password'),
          statusCode: 422,
          data: {
            'message': 'Invalid reset code.',
          },
        ),
      );
    }

    return Response(
      requestOptions: RequestOptions(path: '/auth/reset-password'),
      statusCode: 200,
      data: {
        'message': 'Password reset successfully.',
      },
    );
  }

  @override
  Future<Response> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return Response(
      requestOptions: RequestOptions(path: '/auth/logout'),
      statusCode: 200,
      data: {
        'message': 'Logged out successfully.',
      },
    );
  }
}