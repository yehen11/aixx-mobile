import '../../model/profile_model.dart';
import '../../model/result_history_item_model.dart';
import '../../model/update_profile_request.dart';
import '../apis/profile_api.dart';

class ProfileRepository {
  final ProfileApi _api = ProfileApi();

  Future<ProfileModel> getProfile() => _api.getProfile();

  Future<ProfileModel> updateProfile(
    UpdateProfileRequest request,
  ) =>
      _api.updateProfile(request);

  Future<List<ResultHistoryItemModel>> getResults() => _api.getResults();
}