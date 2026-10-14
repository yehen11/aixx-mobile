import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_config.dart';
import '../../modules/quiz/data/apis/i_quiz_api.dart';
import '../../modules/quiz/data/apis/mock_quiz_api.dart';
import '../../modules/quiz/data/apis/quiz_api.dart';
import '../../modules/quiz/data/repositories/quiz_repository.dart';

final quizApiProvider = Provider<IQuizApi>((ref) {
  if (useTestMode) {
    return MockQuizApi();
  }

  return QuizApi();
});

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(ref.read(quizApiProvider));
});