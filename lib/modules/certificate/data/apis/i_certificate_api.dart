import 'package:dio/dio.dart';

/// Certificate API, per the confirmed backend contract.
/// Both endpoints need the Bearer token.
abstract class ICertificateApi {
  /// GET /certificate
  /// Returns {success, count, data: [certificate...]}.
  Future<Response> getCertificates();

  /// GET /certificate/{id}
  /// Returns {success, data: {certificate}}. 404 if it is missing or
  /// does not belong to the student. The id equals the attempt_id.
  Future<Response> getCertificate(int id);
}