/*
@Author - yehenSamarasinghe
@Date - 2026/09/01
*/

import 'package:dio/dio.dart';
import '../../../../services/core/api_client.dart';
import '../../model/sign_up_model.dart';


class AuthApi {
  static const String _signUpEndpoint = '/api/auth/register';

  Future<Response> signUp(SignUpModel model) {
    return ApiClient.dio.post(_signUpEndpoint, data: model.toJson());
  }
}