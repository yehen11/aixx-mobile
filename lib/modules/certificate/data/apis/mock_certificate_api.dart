import 'package:dio/dio.dart';

import 'i_certificate_api.dart';

class MockCertificateApi implements ICertificateApi {
  /// Flip to true to preview the empty state on the Certificates tab.
  static const bool simulateEmpty = false;

  // Shapes match the backend samples. Id 14 matches the attempt id and the
  // 409 ALREADY_PASSED certificate_id used by MockQuizApi.
  static const List<Map<String, dynamic>> _certificates = [
    {
      'id': 14,
      'certificate_token': 'mock14token',
      'course': 'General AI Knowledge for Everyday Life',
      'course_slug': 'general-ai-knowledge-for-everyday-life',
      'score': 90,
      'issued_at': '2026-10-14T09:30:00+00:00',
      'verify_url': '/api/certificate/verify/mock14token',
    },
    {
      'id': 5,
      'certificate_token': 'abc123',
      'course': 'AI Foundation',
      'course_slug': 'ai-foundation',
      'score': 85,
      'issued_at': '2026-10-10T12:00:00+00:00',
      'verify_url': '/api/certificate/verify/abc123',
    },
  ];

  @override
  Future<Response> getCertificates() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final list = simulateEmpty ? <Map<String, dynamic>>[] : _certificates;

    return Response(
      requestOptions: RequestOptions(path: '/certificate'),
      statusCode: 200,
      data: {
        'success': true,
        'count': list.length,
        'data': list,
      },
    );
  }

  @override
  Future<Response> getCertificate(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final options = RequestOptions(path: '/certificate/$id');

        var matches = simulateEmpty
        ? <Map<String, dynamic>>[]
        : _certificates.where((c) => c['id'] == id).toList();

    // MockQuizApi hands out attempt ids from 14 up, and a passed attempt's
    // id is its certificate id. Give those a certificate too.
    if (matches.isEmpty && !simulateEmpty && id >= 14) {
      matches = [
        {
          'id': id,
          'certificate_token': 'mock-cert-token-$id',
          'course': 'General AI Knowledge for Everyday Life',
          'course_slug': 'general-ai-knowledge-for-everyday-life',
          'score': 90,
          'issued_at': DateTime.now().toIso8601String(),
          'verify_url': '/api/certificate/verify/mock-cert-token-$id',
        },
      ];
    }

    if (matches.isEmpty) {
      // Same as the backend: missing or not owned by this student.
      // The message text is assumed, so don't depend on it in the UI.
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 404,
          data: {'success': false, 'message': 'Certificate not found.'},
        ),
      );
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'success': true, 'data': matches.first},
    );
  }
}