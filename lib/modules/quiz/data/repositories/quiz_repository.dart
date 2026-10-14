import 'package:dio/dio.dart';

import '../apis/i_quiz_api.dart';

class QuizRepository {
  final IQuizApi _api;

  QuizRepository(this._api);

  Future<Response> startAttempt({int? trainingId, String? trainingSlug}) {
    return _api.startAttempt(
      trainingId: trainingId,
      trainingSlug: trainingSlug,
    );
  }

  Future<Response> submitAnswer({
    required int attemptId,
    required int attemptQuestionId,
    required String selectedOption,
  }) {
    return _api.submitAnswer(
      attemptId: attemptId,
      attemptQuestionId: attemptQuestionId,
      selectedOption: selectedOption,
    );
  }

  Future<Response> completeAttempt(int attemptId) {
    return _api.completeAttempt(attemptId);
  }
}