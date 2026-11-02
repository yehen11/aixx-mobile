import 'package:dio/dio.dart';

import '../../model/update_profile_request.dart';
import '../apis/i_profile_api.dart';

class ProfileRepository {
  final IProfileApi _api;

  ProfileRepository(this._api);

  Future<Response> getProfile() => _api.getProfile();

  Future<Response> updateProfile(UpdateProfileRequest request) =>
      _api.updateProfile(request);

  Future<Response> getResults() => _api.getResults();

  Future<Response> getModuleResults() => _api.getModuleResults();
}