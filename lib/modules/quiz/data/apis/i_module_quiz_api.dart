import '../../model/module_quiz_content_model.dart';
import '../../model/module_quiz_result_model.dart';

abstract class IModuleQuizApi {
  Future<ModuleQuizContent> getModuleContent({
    required String courseSlug,
    required int moduleIndex,
  });

  Future<ModuleQuizSubmitResult> submitAnswers({
    required String courseSlug,
    required int moduleIndex,
    required Map<int, String> answers, // questionId -> selected option letter
  });
}