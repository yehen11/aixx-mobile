import 'package:dio/dio.dart';

import '../../../../services/core/api_client.dart';
import 'i_certificate_api.dart';

class CertificateApi implements ICertificateApi {
  @override
  Future<Response> getCertificates() {
    return ApiClient.dio.get('/certificate');
  }

  @override
  Future<Response> getCertificate(int id) {
    return ApiClient.dio.get('/certificate/$id');
  }
}