import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modules/auth/data/apis/auth_api.dart';
import '../../modules/auth/data/apis/i_auth_api.dart';
import '../../modules/auth/data/apis/mock_auth_api.dart';
import '../../modules/auth/data/repositories/auth_repository.dart';
import '../../modules/auth/model/login_request.dart';
import '../../modules/auth/model/register_request.dart';
import '../../modules/auth/model/register_response.dart';

const bool useTestMode = true;

final authApiProvider = Provider<IAuthApi>((ref) {
  if (useTestMode) {
    return MockAuthApi();
  }

  return AuthApi();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(authApiProvider),
  );
});

final signUpUserProvider =
    FutureProvider.family<RegisterResponse, RegisterRequest>((ref, request) async {
  final repository = ref.read(authRepositoryProvider);

  final response = await repository.register(request);

  return RegisterResponse.fromJson(response.data as Map<String, dynamic>);
});

final verifyOtpProvider = FutureProvider.family<Map<String, dynamic>, Map<String, String>>(
  (ref, data) async {
    final repository = ref.read(authRepositoryProvider);

    final response = await repository.verifyOtp(
      email: data['email']!,
      otp: data['otp']!,
    );

    return response.data as Map<String, dynamic>;
  },
);

final resendOtpProvider =
    FutureProvider.family<String, String>(
  (ref, email) async {
    final repository = ref.read(authRepositoryProvider);

    final response = await repository.resendOtp(email);

    final data = response.data as Map<String, dynamic>;

    return data['message'] as String? ?? 'OTP sent successfully.';
  },
);

final loginProvider =
    FutureProvider.family<Map<String, dynamic>, LoginRequest>(
  (ref, request) async {
    final repository = ref.read(authRepositoryProvider);

    final response = await repository.login(request);

    return response.data as Map<String, dynamic>;
  },
);

final forgotPasswordProvider =
    FutureProvider.family<String, String>(
  (ref, email) async {
    final repository = ref.read(authRepositoryProvider);

    final response = await repository.forgotPassword(email);

    final data = response.data as Map<String, dynamic>;

    return data['message'] as String? ??
        'Password reset instructions have been sent.';
  },
);

final resetPasswordProvider = FutureProvider.family<
    String,
    ({
      String email,
      String otp,
      String password,
    })>(
  (ref, data) async {
    final repository = ref.read(authRepositoryProvider);

    final response = await repository.resetPassword(
      email: data.email,
      otp: data.otp,
      password: data.password,
    );

    final responseData = response.data as Map<String, dynamic>;

    return responseData['message'] as String? ??
        'Password reset successfully.';
  },
);