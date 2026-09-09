/// Result of submitting a module's answers.
/// Matches the real response shape from POST /api/assessment/submit:
/// { result, score, percentage, totalQuestions }
///
/// NOTE: the exact type of "result" isn't confirmed yet (could be a
/// plain string like "SCORED", or a nested Result object) — fromJson
/// below handles either case defensively so we don't have to block
/// development on that answer. Once confirmed, this can be tightened
/// to a specific type if needed.
class SubmitResultModel {
  final String result;
  final int score;
  final double percentage;
  final int totalQuestions;

  SubmitResultModel({
    required this.result,
    required this.score,
    required this.percentage,
    required this.totalQuestions,
  });

  factory SubmitResultModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    final resultString = rawResult == null
        ? 'SCORED'
        : (rawResult is String ? rawResult : rawResult.toString());

    return SubmitResultModel(
      result: resultString,
      score: json['score'] as int,
      percentage: (json['percentage'] as num).toDouble(),
      totalQuestions: json['totalQuestions'] as int,
    );
  }
}

/// One answer the learner selected — sent in the submit payload.
class SubmitAnswer {
  final int questionId;
  final int optionId;

  SubmitAnswer({required this.questionId, required this.optionId});

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'optionId': optionId,
      };
}