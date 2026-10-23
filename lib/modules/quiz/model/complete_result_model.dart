/// Response from POST /assessment/attempts/{id}/complete.
class QuestionBreakdown {
  final int questionId;
  final String questionText;
  final String? selectedOption; // option TEXT (e.g. "No"), not the key. null = unanswered
  final bool isCorrect;
  final String? consequenceText; // null when correct

  QuestionBreakdown({
    required this.questionId,
    required this.questionText,
    required this.selectedOption,
    required this.isCorrect,
    required this.consequenceText,
  });

  factory QuestionBreakdown.fromJson(Map<String, dynamic> json) {
    return QuestionBreakdown(
      questionId: json['question_id'] as int,
      questionText: json['question_text'] as String,
      selectedOption: json['selected_option'] as String?,
      isCorrect: json['is_correct'] as bool,
      consequenceText: json['consequence_text'] as String?,
    );
  }
}

/// The `certificate` object the backend is adding to the complete response.
class IssuedCertificate {
  final int id;
  final String token;
  final DateTime? issuedAt;
  final String? verifyUrl;

  IssuedCertificate({
    required this.id,
    required this.token,
    required this.issuedAt,
    required this.verifyUrl,
  });

  factory IssuedCertificate.fromJson(Map<String, dynamic> json) {
    return IssuedCertificate(
      id: json['id'] as int,
      token: json['token'] as String,
      issuedAt: json['issued_at'] != null
          ? DateTime.tryParse(json['issued_at'] as String)
          : null,
      verifyUrl: json['verify_url'] as String?,
    );
  }
}

class CompleteResultModel {
  final bool success;
  final int attemptId;
  final double score;
  final int correctCount;
  final int totalQuestions;
  final bool passed;
  final String? certificateToken;
  final IssuedCertificate? certificate;
  final List<QuestionBreakdown> questionBreakdown;

  CompleteResultModel({
    required this.success,
    required this.attemptId,
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
    required this.passed,
    required this.certificateToken,
    required this.certificate,
    required this.questionBreakdown,
  });

  /// Certificate id equals attempt_id (confirmed by backend), so this works
  /// even before the `certificate` object is deployed.
  int? get certificateId => passed ? (certificate?.id ?? attemptId) : null;

  factory CompleteResultModel.fromJson(Map<String, dynamic> json) {
    return CompleteResultModel(
      success: json['success'] as bool,
      attemptId: json['attempt_id'] as int,
      score: (json['score'] as num).toDouble(),
      correctCount: json['correct_count'] as int,
      totalQuestions: json['total_questions'] as int,
      passed: json['passed'] as bool,
      certificateToken: json['certificate_token'] as String?,
      certificate: json['certificate'] != null
          ? IssuedCertificate.fromJson(json['certificate'] as Map<String, dynamic>)
          : null,
      questionBreakdown: (json['question_breakdown'] as List)
          .map((q) => QuestionBreakdown.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}