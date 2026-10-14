import '../../model/module_quiz_content_model.dart';
import '../../model/module_quiz_result_model.dart';
import '../apis/i_module_quiz_api.dart';

class ModuleQuizRepository {
  final IModuleQuizApi _api;

  ModuleQuizRepository(this._api);

  Future<ModuleQuizContent> getModuleContent({
    required String courseSlug,
    required int moduleIndex,
  }) {
    return _api.getModuleContent(courseSlug: courseSlug, moduleIndex: moduleIndex);
  }

  Future<ModuleQuizSubmitResult> submitAnswers({
    required String courseSlug,
    required int moduleIndex,
    required Map<int, String> answers,
  }) {
    return _api.submitAnswers(courseSlug: courseSlug, moduleIndex: moduleIndex, answers: answers);
  }
}