/// One final assessment attempt from GET /assessment/results.
class ResultHistoryItemModel {
  final int attemptId;
  final String courseTitle; // "training" in the API
  final String courseSlug;
  final double score; // percentage, e.g. 85
  final bool passed;
  final DateTime? completedAt;
  final String? certificateToken; // null when the attempt failed

  const ResultHistoryItemModel({
    required this.attemptId,
    required this.courseTitle,
    required this.courseSlug,
    required this.score,
    required this.passed,
    required this.completedAt,
    required this.certificateToken,
  });

  /// The certificate id equals the attempt id. Null for a failed attempt.
  int? get certificateId => certificateToken == null ? null : attemptId;

  String get scoreLabel => '${score.round()}%';

  /// e.g. "14 Oct 2026". Empty when the backend sent no date.
  String get dateLabel {
    final d = completedAt;
    if (d == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  factory ResultHistoryItemModel.fromJson(Map<String, dynamic> json) {
    final token = json['certificate_token'] as String?;

    return ResultHistoryItemModel(
      attemptId: (json['attempt_id'] as num).toInt(),
      courseTitle: (json['training'] ?? '') as String,
      courseSlug: (json['training_slug'] ?? '') as String,
      score: (json['score'] as num?)?.toDouble() ?? 0,
      passed: json['passed'] as bool? ?? false,
      completedAt:
          DateTime.tryParse((json['completed_at'] ?? '') as String)?.toLocal(),
      certificateToken: (token == null || token.isEmpty) ? null : token,
    );
  }
}