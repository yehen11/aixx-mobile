class ModuleModel {
  final int id;
  final int moduleIndex;
  final String title;
  final String? studyNotes;
  final int questionsCount;
  final String status; // "Available" or "Completed" — exact, case-sensitive
  final bool isCompleted;
  final double? score;
  final bool passed;
  final String actionUrl;

  ModuleModel({
    required this.id,
    required this.moduleIndex,
    required this.title,
    required this.studyNotes,
    required this.questionsCount,
    required this.status,
    required this.isCompleted,
    required this.score,
    required this.passed,
    required this.actionUrl,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] as int,
      moduleIndex: json['module_index'] as int,
      title: json['title'] as String,
      studyNotes: json['study_notes'] as String?,
      questionsCount: json['questions_count'] as int,
      status: json['status'] as String,
      isCompleted: json['is_completed'] as bool? ?? false,
      score: (json['score'] as num?)?.toDouble(),
      passed: json['passed'] as bool? ?? false,
      actionUrl: json['action_url'] as String,
    );
  }
}