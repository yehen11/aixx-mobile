import '../../../../services/core/api_client.dart';
import '../../model/question_model.dart';
import '../../model/submit_result_model.dart';

const bool kUseMockQuizData = true;

class QuizApi {
  /// Fetch questions for a specific module.
  Future<List<QuestionModel>> getQuestions(int moduleId) async {
    // Use mock data while backend is not hosted.
    if (kUseMockQuizData) {
      await Future.delayed(
        const Duration(milliseconds: 400),
      );

      return List.generate(6, (i) {
        final qId = moduleId * 100 + i + 1;

        return QuestionModel(
          id: qId,
          text: 'Sample question ${i + 1} for this module?',
          options: [
            OptionModel(
              id: qId * 10 + 1,
              text: 'Option A',
            ),
            OptionModel(
              id: qId * 10 + 2,
              text: 'Option B',
            ),
            OptionModel(
              id: qId * 10 + 3,
              text: 'Option C',
            ),
            OptionModel(
              id: qId * 10 + 4,
              text: 'Option D',
            ),
          ],
        );
      });
    }

    // Real backend request.
    final response = await ApiClient.dio.get(
      '/api/assessment/modules/$moduleId/questions',
    );

    final List data = response.data as List;

    return data
        .map(
          (json) => QuestionModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Submit the learner's answers for a module.
  Future<SubmitResultModel> submitAnswers({
    required int moduleId,
    required List<SubmitAnswer> answers,
  }) async {
    // Use mock scoring while backend is not hosted.
    if (kUseMockQuizData) {
      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      // Fake a plausible score for UI testing.
      final fakeScore = (answers.length * 0.7).round();
      final fakePercentage =
          answers.isEmpty ? 0.0 : (fakeScore / answers.length) * 100;

      return SubmitResultModel(
        result: ResultRecord(
          id: 0,
          alumniId: 0,
          moduleId: moduleId,
          score: fakeScore,
          state: 'SCORED',
          createdAt: DateTime.now(),
        ),
        score: fakeScore,
        percentage: fakePercentage,
        totalQuestions: answers.length,
      );
    }

    // Real backend request.
    final response = await ApiClient.dio.post(
      '/api/assessment/submit',
      data: {
        'moduleId': moduleId,
        'answers': answers
            .map((answer) => answer.toJson())
            .toList(),
      },
    );

    return SubmitResultModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}