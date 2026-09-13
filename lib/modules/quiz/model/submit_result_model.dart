/// Result of submitting a module's answers.
/// CONFIRMED against a real sample response from the backend developer
/// (2026-09-09) — POST /api/assessment/submit returns:
/// {
///   "result": { id, alumniId, moduleId, score, state, createdAt, updatedAt },
///   "score": int,
///   "percentage": number,
///   "totalQuestions": int
/// }
/// "result" is the nested Prisma Result record, NOT a plain string.
class ResultRecord {
  final int id;
  final int alumniId;
  final int moduleId;
  final int score;
  final String state; // e.g. "SCORED"
  final DateTime createdAt;

  ResultRecord({
    required this.id,
    required this.alumniId,
    required this.moduleId,
    required this.score,
    required this.state,
    required this.createdAt,
  });

  factory ResultRecord.fromJson(Map<String, dynamic> json) {
    return ResultRecord(
      id: json['id'] as int,
      alumniId: json['alumniId'] as int,
      moduleId: json['moduleId'] as int,
      score: json['score'] as int,
      state: json['state'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class SubmitResultModel {
  final ResultRecord result;
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
    return SubmitResultModel(
      result: ResultRecord.fromJson(json['result'] as Map<String, dynamic>),
      score: json['score'] as int,
      percentage: (json['percentage'] as num).toDouble(),
      totalQuestions: json['totalQuestions'] as int,
    );
  }
}

/// One answer the learner selected — sent in the submit payload.
/// Confirmed matches the real request shape exactly:
/// { "moduleId": ..., "answers": [{ "questionId": ..., "optionId": ... }] }
class SubmitAnswer {
  final int questionId;
  final int optionId;

  SubmitAnswer({required this.questionId, required this.optionId});

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'optionId': optionId,
      };
}