import '../../model/question_model.dart';
import '../../model/submit_result_model.dart';
import '../apis/quiz_api.dart';

class QuizRepository {
  final QuizApi _api = QuizApi();

  /// Get all questions for a module.
  Future<List<QuestionModel>> getQuestions(int moduleId) {
    return _api.getQuestions(moduleId);
  }

  /// Submit the learner's answers for a module.
  Future<SubmitResultModel> submitAnswers({
    required int moduleId,
    required List<SubmitAnswer> answers,
  }) {
    return _api.submitAnswers(
      moduleId: moduleId,
      answers: answers,
    );
  }
}