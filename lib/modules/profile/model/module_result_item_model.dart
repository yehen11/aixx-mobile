/// One row of GET /me/module-results: a module the student has attempted,
/// with their best/last score and attempt count (one row per module).
class ModuleResultItemModel {
  final String course;
  final String courseSlug;
  final int moduleIndex;
  final String? moduleTitle; // null for courses without real module titles
  final double bestScore;
  final double lastScore;
  final bool passed;
  final int attempts;
  final DateTime? completedAt;
  final DateTime? lastAttemptedAt;

  const ModuleResultItemModel({
    required this.course,
    required this.courseSlug,
    required this.moduleIndex,
    required this.moduleTitle,
    required this.bestScore,
    required this.lastScore,
    required this.passed,
    required this.attempts,
    required this.completedAt,
    required this.lastAttemptedAt,
  });

  String get moduleName {
    final t = moduleTitle?.trim();
    return (t == null || t.isEmpty) ? 'Module $moduleIndex' : t;
  }

  String get bestScoreLabel => '${bestScore.round()}%';

  String get attemptsLabel => attempts == 1 ? '1 attempt' : '$attempts attempts';

  /// e.g. "2 Nov 2026" (the last attempt). Empty when there is no date.
  String get dateLabel {
    final d = lastAttemptedAt ?? completedAt;
    if (d == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  factory ModuleResultItemModel.fromJson(Map<String, dynamic> json) {
    DateTime? date(String key) =>
        DateTime.tryParse((json[key] ?? '') as String)?.toLocal();

    return ModuleResultItemModel(
      course: (json['course'] ?? '') as String,
      courseSlug: (json['course_slug'] ?? '') as String,
      moduleIndex: (json['module_index'] as num).toInt(),
      moduleTitle: json['module_title'] as String?,
      bestScore: (json['best_score'] as num?)?.toDouble() ?? 0,
      lastScore: (json['last_score'] as num?)?.toDouble() ?? 0,
      passed: json['passed'] as bool? ?? false,
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      completedAt: date('completed_at'),
      lastAttemptedAt: date('last_attempted_at'),
    );
  }
}