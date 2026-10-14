import 'package:dio/dio.dart';

import '../../../../services/core/api_client.dart';
import 'i_quiz_api.dart';

class QuizApi implements IQuizApi {
  @override
  Future<Response> startAttempt({int? trainingId, String? trainingSlug}) {
    assert(
      trainingId != null || trainingSlug != null,
      'Either trainingId or trainingSlug must be provided.',
    );

    return ApiClient.dio.post(
      '/assessment/attempts',
      data: {
        if (trainingId != null) 'training_id': trainingId,
        if (trainingSlug != null) 'training_slug': trainingSlug,
      },
    );
  }

  @override
  Future<Response> submitAnswer({
    required int attemptId,
    required int attemptQuestionId,
    required String selectedOption,
  }) {
    return ApiClient.dio.post(
      '/assessment/attempts/$attemptId/answers',
      data: {
        'attempt_question_id': attemptQuestionId,
        'selected_option': selectedOption,
      },
    );
  }

  @override
  Future<Response> completeAttempt(int attemptId) {
    return ApiClient.dio.post('/assessment/attempts/$attemptId/complete');
  }
}