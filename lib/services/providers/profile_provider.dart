import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_config.dart';
import '../../modules/profile/data/apis/i_profile_api.dart';
import '../../modules/profile/data/apis/mock_profile_api.dart';
import '../../modules/profile/data/apis/profile_api.dart';
import '../../modules/profile/data/repositories/profile_repository.dart';
import '../../modules/profile/model/profile_model.dart';
import '../../modules/profile/model/result_history_item_model.dart';
import '../../modules/profile/model/update_profile_request.dart';
import '../../modules/profile/model/module_result_item_model.dart';

final profileApiProvider = Provider<IProfileApi>((ref) {
  if (useTestMode) {
    return MockProfileApi();
  }

  return ProfileApi();
});

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.read(profileApiProvider)),
);

/// The current student's profile (GET /me).
final profileProvider = FutureProvider<ProfileModel>((ref) async {
  final response = await ref.read(profileRepositoryProvider).getProfile();

  return ProfileModel.fromJson(response.data as Map<String, dynamic>);
});

/// Final assessment attempts, newest first.
final resultHistoryProvider =
    FutureProvider<List<ResultHistoryItemModel>>((ref) async {
  final response = await ref.read(profileRepositoryProvider).getResults();

  final list = (response.data['data'] as List)
      .map((j) => ResultHistoryItemModel.fromJson(j as Map<String, dynamic>))
      .toList();

  // Don't rely on backend ordering. Attempts without a date go last.
  list.sort((a, b) {
    final aDate = a.completedAt;
    final bDate = b.completedAt;
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    return bDate.compareTo(aDate);
  });

  return list;
});

/// Updates the profile, then re-fetches it. The PUT /me response shape isn't
/// documented, so the UI never depends on it.
Future<void> updateProfile(
  WidgetRef ref,
  UpdateProfileRequest request,
) async {
  await ref.read(profileRepositoryProvider).updateProfile(request);

  ref.invalidate(profileProvider);
}

/// Modules the student has attempted, most recently attempted first.
final moduleResultsProvider =
    FutureProvider<List<ModuleResultItemModel>>((ref) async {
  final response =
      await ref.read(profileRepositoryProvider).getModuleResults();

  final list = (response.data['data'] as List)
      .map((j) => ModuleResultItemModel.fromJson(j as Map<String, dynamic>))
      .toList();

  list.sort((a, b) {
    final aDate = a.lastAttemptedAt;
    final bDate = b.lastAttemptedAt;
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    return bDate.compareTo(aDate);
  });

  return list;
});