import 'package:dio/dio.dart';

import '../apis/i_certificate_api.dart';

class CertificateRepository {
  final ICertificateApi _api;

  CertificateRepository(this._api);

  Future<Response> getCertificates() {
    return _api.getCertificates();
  }

  Future<Response> getCertificate(int id) {
    return _api.getCertificate(id);
  }
}