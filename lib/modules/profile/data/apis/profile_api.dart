import 'package:dio/dio.dart';

import '../../../../services/core/api_client.dart';
import '../../model/update_profile_request.dart';
import 'i_profile_api.dart';

class ProfileApi implements IProfileApi {
  // Paths don't start with /api: the base URL already ends in it.

  @override
  Future<Response> getProfile() {
    return ApiClient.dio.get('/me');
  }

  @override
  Future<Response> updateProfile(UpdateProfileRequest request) {
    return ApiClient.dio.put('/me', data: request.toJson());
  }

  @override
  Future<Response> getResults() {
    return ApiClient.dio.get('/assessment/results');
  }

    @override
  Future<Response> getModuleResults() {
    return ApiClient.dio.get('/me/module-results');
  }
}