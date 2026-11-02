import 'package:dio/dio.dart';

import '../../model/update_profile_request.dart';

/// Profile and Results History API. All endpoints need the Bearer token.
abstract class IProfileApi {
  /// GET /me
  /// Returns { profile{...}, entitlements{...}, aiks{...}|null }.
  Future<Response> getProfile();

  /// PUT /me with full_name, phone and country.
  /// The response shape isn't documented, so callers must not parse it.
  /// Re-fetch with getProfile() after a successful update.
  Future<Response> updateProfile(UpdateProfileRequest request);

  /// GET /assessment/results (final assessment attempts only)
  /// Returns { success, count, data: [ { attempt_id, training, training_slug,
  /// score, passed, completed_at, certificate_token|null } ] }.
  Future<Response> getResults();

    /// GET /me/module-results
  /// Returns { success, count, data: [ { course, course_slug, module_index,
  /// module_title|null, best_score, last_score, passed, attempts,
  /// completed_at|null, last_attempted_at } ] }.
  Future<Response> getModuleResults();
}