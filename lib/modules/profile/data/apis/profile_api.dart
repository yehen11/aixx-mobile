import '../../../../services/core/api_client.dart';
import '../../model/profile_model.dart';
import '../../model/result_history_item_model.dart';
import '../../model/update_profile_request.dart';

/// Profile + Results History API — mock now, real backend once hosted,
/// controlled by [kUseMockProfileData].
///
/// Confirmed real endpoints:
///   GET /api/auth/profile
///   GET /api/assessment/results
///
/// NOT YET CONFIRMED — placeholder pending backend dev's reply:
///   PUT /api/auth/profile
const bool kUseMockProfileData = true;

class ProfileApi {
  // Mock in-memory state so edits persist across the session for testing.
  ProfileModel _mockProfile = ProfileModel(
    id: 1,
    email: 'jane.doe@example.com',
    name: 'Jane Doe',
    state: 'ACTIVE',
    createdAt: DateTime.now().subtract(const Duration(days: 14)),
    avatarUrl: null,
  );

  Future<ProfileModel> getProfile() async {
    if (kUseMockProfileData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return _mockProfile;
    }

    final response = await ApiClient.dio.get('/api/auth/profile');
    return ProfileModel.fromJson(response.data);
  }

  /// TODO: PUT /api/auth/profile is NOT confirmed to exist yet.
  Future<ProfileModel> updateProfile(
    UpdateProfileRequest request,
  ) async {
    if (kUseMockProfileData) {
      await Future.delayed(const Duration(milliseconds: 400));

      _mockProfile = ProfileModel(
        id: _mockProfile.id,
        email: _mockProfile.email,
        name: request.name,
        state: _mockProfile.state,
        createdAt: _mockProfile.createdAt,
        avatarUrl: request.avatarUrl ?? _mockProfile.avatarUrl,
      );

      return _mockProfile;
    }

    final response = await ApiClient.dio.put(
      '/api/auth/profile',
      data: request.toJson(),
    );

    return ProfileModel.fromJson(response.data);
  }

  Future<List<ResultHistoryItemModel>> getResults() async {
    if (kUseMockProfileData) {
      await Future.delayed(const Duration(milliseconds: 300));

      return [
        ResultHistoryItemModel(
          id: 1,
          moduleTitle: 'AI Basics',
          courseTitle: 'General AI Knowledge for Everyday Life',
          score: 5,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        ResultHistoryItemModel(
          id: 2,
          moduleTitle: 'AI in Everyday Life',
          courseTitle: 'General AI Knowledge for Everyday Life',
          score: 4,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
    }

    final response = await ApiClient.dio.get(
      '/api/assessment/results',
    );

    final List data = response.data as List;

    return data
        .map(
          (json) => ResultHistoryItemModel.fromJson(json),
        )
        .toList();
  }
}