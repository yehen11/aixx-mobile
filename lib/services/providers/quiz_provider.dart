import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modules/quiz/data/repositories/quiz_repository.dart';
import '../../modules/quiz/model/question_model.dart';

/// Provides the QuizRepository instance.
final quizRepositoryProvider = Provider<QuizRepository>(
  (ref) => QuizRepository(),
);

/// Provides questions for a specific module.
///
/// The questions are fetched when the quiz session screen
/// requests this provider.
final quizQuestionsProvider =
    FutureProvider.family<List<QuestionModel>, int>(
  (ref, moduleId) async {
    final repository = ref.read(quizRepositoryProvider);

    return repository.getQuestions(moduleId);
  },
);