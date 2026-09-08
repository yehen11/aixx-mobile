/// Module model — matches the REAL backend schema exactly
/// (Backend_API_Documentation.docx, Section 5: Module table).
/// Real fields: id (Int), title, description, courseId (Int FK).
/// No `theme`, `sequence`, or `questionCount` on the backend —
/// display order uses the list index; question count per module
/// requires a separate call to the Assessment API (Day 5).
class ModuleModel {
  final int id;
  final int courseId;
  final String title;
  final String description;

  ModuleModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] as int,
      courseId: json['courseId'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
    );
  }
}