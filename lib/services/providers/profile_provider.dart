import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modules/profile/data/repositories/profile_repository.dart';
import '../../modules/profile/model/profile_model.dart';
import '../../modules/profile/model/result_history_item_model.dart';
import '../../modules/profile/model/update_profile_request.dart';

/// Provides the ProfileRepository instance.
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(),
);

/// Fetches the current user's profile.
///
/// The provider automatically exposes:
/// - loading state
/// - profile data
/// - error state
final profileProvider = FutureProvider<ProfileModel>((ref) async {
  final repo = ref.read(profileRepositoryProvider);

  return repo.getProfile();
});

/// Fetches the user's quiz/result history.
final resultHistoryProvider =
    FutureProvider<List<ResultHistoryItemModel>>((ref) async {
  final repo = ref.read(profileRepositoryProvider);

  return repo.getResults();
});

/// Updates the user's profile.
///
/// After a successful update, [profileProvider] is invalidated
/// so the UI automatically fetches and displays the latest profile.
Future<void> updateProfile(
  WidgetRef ref,
  UpdateProfileRequest request,
) async {
  final repo = ref.read(profileRepositoryProvider);

  await repo.updateProfile(request);

  ref.invalidate(profileProvider);
}