import 'package:dio/dio.dart';
import '../../model/sign_up_model.dart';
import '../apis/auth_api.dart';

/// Business-facing repository — matches adgo-mobile's pattern.
/// Returns the raw Dio Response; the provider parses it.
class AuthRepository {
  final AuthApi _api = AuthApi();

  Future<Response> signUp(SignUpModel model) {
    return _api.signUp(model);
  }
}