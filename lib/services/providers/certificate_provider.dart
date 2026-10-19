import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_config.dart';
import '../../modules/certificate/data/apis/certificate_api.dart';
import '../../modules/certificate/data/apis/i_certificate_api.dart';
import '../../modules/certificate/data/apis/mock_certificate_api.dart';
import '../../modules/certificate/data/repositories/certificate_repository.dart';
import '../../modules/certificate/model/certificate_model.dart';

final certificateApiProvider = Provider<ICertificateApi>((ref) {
  if (useTestMode) {
    return MockCertificateApi();
  }

  return CertificateApi();
});

final certificateRepositoryProvider = Provider<CertificateRepository>((ref) {
  return CertificateRepository(ref.read(certificateApiProvider));
});

/// All of the student's certificates, newest first.
/// Call ref.invalidate(certificateListProvider) after a pass and on logout.
final certificateListProvider =
    FutureProvider<List<CertificateModel>>((ref) async {
  final response =
      await ref.read(certificateRepositoryProvider).getCertificates();

  final list = (response.data['data'] as List)
      .map((json) => CertificateModel.fromJson(json as Map<String, dynamic>))
      .toList();

  // Don't rely on backend ordering. Certificates without a date go last.
  list.sort((a, b) {
    final aDate = a.issuedAt;
    final bDate = b.issuedAt;
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    return bDate.compareTo(aDate);
  });

  return list;
});

/// One certificate by id (id == final assessment attempt_id).
/// A 404 surfaces as a DioException, so the detail screen shows "not found".
final certificateDetailProvider =
    FutureProvider.autoDispose.family<CertificateModel, int>((ref, id) async {
  final response =
      await ref.read(certificateRepositoryProvider).getCertificate(id);

  return CertificateModel.fromJson(
    response.data['data'] as Map<String, dynamic>,
  );
});