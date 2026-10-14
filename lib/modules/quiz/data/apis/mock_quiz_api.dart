import 'package:dio/dio.dart';

import 'i_quiz_api.dart';

class MockQuizApi implements IQuizApi {
  /// Flip to true to preview the 409 ALREADY_PASSED path.
  static const bool simulateAlreadyPassed = false;

  static int _nextAttemptId = 14;
  static int? _activeAttemptId;
  static final Map<int, String> _answers = {}; // attemptQuestionId -> option key

  static const List<_MockQuestion> _questions = [
    _MockQuestion(
      text: 'A vendor asks for database credentials to "speed up" an integration. What should you do first?',
      options: {
        'A': 'Share them to avoid delaying the project',
        'B': 'Verify their access permissions against company policy',
        'C': 'Email the credentials in plain text',
        'D': 'Create a shared admin account for them',
      },
      correct: 'B',
      consequence:
          'Cost/Consequence: Unverified vendor access led to a security breach, a \$50,000 regulatory fine and exposure of sensitive customer data.',
    ),
    _MockQuestion(
      text: 'What is the safest way to use a public AI chatbot at work?',
      options: {
        'A': 'Paste customer records so it can summarize them',
        'B': 'Upload the full client contract for a quick review',
        'C': 'Share only anonymized, non-confidential information',
        'D': 'Use a personal account so IT cannot see it',
      },
      correct: 'C',
      consequence:
          'Cost/Consequence: Confidential client data pasted into a public AI tool was retained by the provider, triggering a data-protection investigation and contract penalties.',
    ),
    _MockQuestion(
      text: 'An AI tool gives a confident answer containing a statistic. Before putting it in a client report you should:',
      options: {
        'A': 'Verify it against a reliable source first',
        'B': 'Include it, since the AI sounded sure',
        'C': 'Ask the AI again and trust it if the numbers match',
        'D': 'Delete the source references to keep the report clean',
      },
      correct: 'A',
      consequence:
          'Cost/Consequence: An unverified AI-generated figure in a client report forced a corrected filing, damaged the firm\'s reputation and cost the client contract.',
    ),
    _MockQuestion(
      text: 'Is multi-factor authentication enforced for remote management?',
      options: {
        'A': 'Yes, for all remote access',
        'B': 'Only for administrator accounts',
        'C': 'No, strong passwords are enough',
        'D': 'Only when a user requests it',
      },
      correct: 'A',
      consequence:
          'Cost/Consequence: Compromised remote credentials without MFA let an attacker into internal systems, causing downtime and a mandatory breach notification.',
    ),
    _MockQuestion(
      text: 'Your organization has an approved AI tools list. A colleague suggests an unapproved free tool for speed. You should:',
      options: {
        'A': 'Use it just this once',
        'B': 'Use it on a personal laptop instead',
        'C': 'Say nothing and let them proceed',
        'D': 'Stick to approved tools and request a review of the new one',
      },
      correct: 'D',
      consequence:
          'Cost/Consequence: Use of an unapproved AI tool bypassed data-handling controls, resulting in a policy violation finding and a full compliance audit.',
    ),
  ];

  @override
  Future<Response> startAttempt({int? trainingId, String? trainingSlug}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final options = RequestOptions(path: '/assessment/attempts');

    if (simulateAlreadyPassed) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 409,
          data: {
            'success': false,
            'code': 'ALREADY_PASSED',
            'certificate_id': 14,
          },
        ),
      );
    }

    final resumed = _activeAttemptId != null;
    _activeAttemptId ??= _nextAttemptId++;
    if (!resumed) _answers.clear();

    return Response(
      requestOptions: options,
      statusCode: resumed ? 200 : 201,
      data: {
        'success': true,
        'attempt_id': _activeAttemptId,
        'is_resumed': resumed,
        'questions': [
          for (var i = 0; i < _questions.length; i++)
            {
              'attempt_question_id': 500 + i + 1,
              'question': _questions[i].text,
              'options': _questions[i].options,
              'selected_option': _answers[500 + i + 1],
            },
        ],
      },
    );
  }

  @override
  Future<Response> submitAnswer({
    required int attemptId,
    required int attemptQuestionId,
    required String selectedOption,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    _answers[attemptQuestionId] = selectedOption;

    return Response(
      requestOptions: RequestOptions(path: '/assessment/attempts/$attemptId/answers'),
      statusCode: 200,
      data: {'success': true, 'message': 'Answer recorded.'},
    );
  }

  @override
  Future<Response> completeAttempt(int attemptId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var correctCount = 0;
    final breakdown = <Map<String, dynamic>>[];

    for (var i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final selectedKey = _answers[500 + i + 1];
      final isCorrect = selectedKey == q.correct;
      if (isCorrect) correctCount++;

      breakdown.add({
        'question_id': 500 + i + 1,
        'question_text': q.text,
        // The real API returns the option TEXT here, not the key.
        'selected_option': selectedKey == null ? 'No answer' : q.options[selectedKey],
        'is_correct': isCorrect,
        'consequence_text': isCorrect ? null : q.consequence,
      });
    }

    final total = _questions.length;
    final score = (correctCount / total) * 100;
    final passed = score >= 80;
    final token = 'mock-cert-token-$attemptId';

    _activeAttemptId = null;
    _answers.clear();

    return Response(
      requestOptions: RequestOptions(path: '/assessment/attempts/$attemptId/complete'),
      statusCode: 200,
      data: {
        'success': true,
        'attempt_id': attemptId,
        'score': score,
        'correct_count': correctCount,
        'total_questions': total,
        'passed': passed,
        'certificate_token': passed ? token : null,
        'certificate': passed
            ? {
                'id': attemptId,
                'token': token,
                'issued_at': DateTime.now().toIso8601String(),
                'verify_url': '/certificate/verify/$token',
              }
            : null,
        'question_breakdown': breakdown,
      },
    );
  }
}

class _MockQuestion {
  final String text;
  final Map<String, String> options;
  final String correct;
  final String consequence;

  const _MockQuestion({
    required this.text,
    required this.options,
    required this.correct,
    required this.consequence,
  });
}