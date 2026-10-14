class ModuleQuizResultItem {
  final int questionId;
  final String selectedOption;
  final bool isCorrect;
  final String? explanation;

  ModuleQuizResultItem({
    required this.questionId,
    required this.selectedOption,
    required this.isCorrect,
    required this.explanation,
  });

  factory ModuleQuizResultItem.fromJson(Map<String, dynamic> json) {
    return ModuleQuizResultItem(
      questionId: json['question_id'] as int,
      selectedOption: json['selected_option'] as String,
      isCorrect: json['is_correct'] as bool,
      explanation: json['explanation'] as String?,
    );
  }
}

class NextModuleInfo {
  final int moduleIndex;
  final bool unlocked;
  final String url;

  NextModuleInfo({
    required this.moduleIndex,
    required this.unlocked,
    required this.url,
  });

  factory NextModuleInfo.fromJson(Map<String, dynamic> json) {
    return NextModuleInfo(
      moduleIndex: json['module_index'] as int,
      unlocked: json['unlocked'] as bool,
      url: json['url'] as String,
    );
  }
}

class ModuleQuizSubmitResult {
  final bool success;
  final int moduleIndex;
  final double score;
  final int correctCount;
  final int totalQuestions;
  final bool passed;
  final String message;
  final NextModuleInfo? nextModule; // null on the final module
  final List<ModuleQuizResultItem> results;

  ModuleQuizSubmitResult({
    required this.success,
    required this.moduleIndex,
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
    required this.passed,
    required this.message,
    required this.nextModule,
    required this.results,
  });

  factory ModuleQuizSubmitResult.fromJson(Map<String, dynamic> json) {
    return ModuleQuizSubmitResult(
      success: json['success'] as bool,
      moduleIndex: json['module_index'] as int,
      score: (json['score'] as num).toDouble(),
      correctCount: json['correct_count'] as int,
      totalQuestions: json['total_questions'] as int,
      passed: json['passed'] as bool,
      message: json['message'] as String,
      nextModule: json['next_module'] != null
          ? NextModuleInfo.fromJson(json['next_module'] as Map<String, dynamic>)
          : null,
      results: (json['results'] as List)
          .map((r) => ModuleQuizResultItem.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }
}