import 'package:dio/dio.dart';

import '../../model/update_profile_request.dart';
import 'i_profile_api.dart';

class MockProfileApi implements IProfileApi {
  /// Flip to true to preview a student with no AIKS score yet (aiks: null).
  static const bool simulateNoAiks = false;

  // In-memory state so edits persist for the session. The shape matches
  // the backend's GET /me sample.
  final Map<String, dynamic> _profile = {
    'id': 12,
    'uuid': '9b1e2f34-0000-4000-8000-000000000012',
    'registration_id': 'AIXX-ALM-12',
    'full_name': 'Jane Doe',
    'email': 'jane.doe@example.com',
    'phone': '+94771234567',
    'country': 'Sri Lanka',
    'gender': null,
    'company_name': null,
    'academic_institution': null,
    'email_verified_at': '2026-10-01T10:00:00+00:00',
    'preferences': {},
    'last_login_at': '2026-10-14T08:00:00+00:00',
    'avatar_url': null, // always null until avatar upload is built
  };

  @override
  Future<Response> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return Response(
      requestOptions: RequestOptions(path: '/me'),
      statusCode: 200,
      data: {
        'profile': Map<String, dynamic>.from(_profile),
        'entitlements': {'enrolled_courses': [], 'is_ambassador': false},
        // The level text is invented. The backend sample only shows "...".
        'aiks': simulateNoAiks
            ? null
            : {
                'score': 72,
                'level': 'Intermediate',
                'created_at': '2026-10-05T09:00:00+00:00',
              },
      },
    );
  }

  @override
  Future<Response> updateProfile(UpdateProfileRequest request) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final options = RequestOptions(path: '/me');

    // Laravel-style validation error, like the real API's 422 responses.
    if (request.fullName.trim().isEmpty) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 422,
          data: {
            'message': 'The full name field is required.',
            'errors': {
              'full_name': ['The full name field is required.'],
            },
          },
        ),
      );
    }

    _profile['full_name'] = request.fullName.trim();
    if (request.phone != null) _profile['phone'] = request.phone;
    if (request.country != null) _profile['country'] = request.country;

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'success': true},
    );
  }

  @override
  Future<Response> getResults() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Ids 14 and 5 match the certificates in MockCertificateApi.
    // The failed attempt (id 4) has certificate_token: null, as in the real API.
    final results = [
      {
        'attempt_id': 14,
        'training': 'General AI Knowledge for Everyday Life',
        'training_slug': 'general-ai-knowledge-for-everyday-life',
        'score': 90,
        'passed': true,
        'completed_at': '2026-10-14T09:30:00+00:00',
        'certificate_token': 'mock14token',
      },
      {
        'attempt_id': 5,
        'training': 'AI Foundation',
        'training_slug': 'ai-foundation',
        'score': 85,
        'passed': true,
        'completed_at': '2026-10-10T12:00:00+00:00',
        'certificate_token': 'abc123',
      },
      {
        'attempt_id': 4,
        'training': 'AI Foundation',
        'training_slug': 'ai-foundation',
        'score': 60,
        'passed': false,
        'completed_at': '2026-10-08T15:20:00+00:00',
        'certificate_token': null,
      },
    ];

    return Response(
      requestOptions: RequestOptions(path: '/assessment/results'),
      statusCode: 200,
      data: {
        'success': true,
        'count': results.length,
        'data': results,
      },
    );
  }

    @override
  Future<Response> getModuleResults() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final results = [
      {
        'course': 'General AI Knowledge for Everyday Life',
        'course_slug': 'general-ai-knowledge-for-everyday-life',
        'module_index': 2,
        'module_title': 'Module 2: Everyday AI Tools',
        'best_score': 80,
        'last_score': 73,
        'passed': true,
        'attempts': 2,
        'completed_at': '2026-10-13T10:00:00+00:00',
        'last_attempted_at': '2026-10-13T14:30:00+00:00',
      },
      {
        'course': 'General AI Knowledge for Everyday Life',
        'course_slug': 'general-ai-knowledge-for-everyday-life',
        'module_index': 1,
        'module_title': null,
        'best_score': 100,
        'last_score': 100,
        'passed': true,
        'attempts': 1,
        'completed_at': '2026-10-12T09:00:00+00:00',
        'last_attempted_at': '2026-10-12T09:00:00+00:00',
      },
      {
        'course': 'AI Foundation',
        'course_slug': 'ai-foundation',
        'module_index': 3,
        'module_title': null,
        'best_score': 53,
        'last_score': 53,
        'passed': false,
        'attempts': 1,
        'completed_at': null,
        'last_attempted_at': '2026-10-09T16:20:00+00:00',
      },
    ];

    return Response(
      requestOptions: RequestOptions(path: '/me/module-results'),
      statusCode: 200,
      data: {'success': true, 'count': results.length, 'data': results},
    );
  }
}