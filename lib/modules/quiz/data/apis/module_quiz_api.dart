import '../../../../services/core/api_client.dart';
import '../../model/module_quiz_content_model.dart';
import '../../model/module_quiz_result_model.dart';
import 'i_module_quiz_api.dart';

class ModuleQuizApi implements IModuleQuizApi {
  @override
  Future<ModuleQuizContent> getModuleContent({
    required String courseSlug,
    required int moduleIndex,
  }) async {
    final response = await ApiClient.dio.get(
      '/courses/$courseSlug/modules/$moduleIndex',
    );

    return ModuleQuizContent.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ModuleQuizSubmitResult> submitAnswers({
    required String courseSlug,
    required int moduleIndex,
    required Map<int, String> answers,
  }) async {
    final response = await ApiClient.dio.post(
      '/courses/$courseSlug/modules/$moduleIndex/submit-quiz',
      data: {
        'answers': answers.map((qId, opt) => MapEntry(qId.toString(), opt)),
      },
    );

    return ModuleQuizSubmitResult.fromJson(response.data as Map<String, dynamic>);
  }
}