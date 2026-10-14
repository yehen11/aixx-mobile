import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_config.dart';
import '../../modules/quiz/data/apis/i_module_quiz_api.dart';
import '../../modules/quiz/data/apis/mock_module_quiz_api.dart';
import '../../modules/quiz/data/apis/module_quiz_api.dart';
import '../../modules/quiz/data/repositories/module_quiz_repository.dart';
import '../../modules/quiz/model/module_quiz_content_model.dart';

final moduleQuizApiProvider = Provider<IModuleQuizApi>((ref) {
  if (useTestMode) {
    return MockModuleQuizApi();
  }

  return ModuleQuizApi();
});

final moduleQuizRepositoryProvider = Provider<ModuleQuizRepository>((ref) {
  return ModuleQuizRepository(ref.read(moduleQuizApiProvider));
});

final moduleContentProvider = FutureProvider.family<
    ModuleQuizContent,
    ({String courseSlug, int moduleIndex})>((ref, args) async {
  final repository = ref.read(moduleQuizRepositoryProvider);

  return repository.getModuleContent(
    courseSlug: args.courseSlug,
    moduleIndex: args.moduleIndex,
  );
});