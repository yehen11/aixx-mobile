class ResultHistoryItemModel {
  final int id;
  final String moduleTitle;
  final String courseTitle;
  final int score;
  final DateTime createdAt;

  const ResultHistoryItemModel({
    required this.id,
    required this.moduleTitle,
    required this.courseTitle,
    required this.score,
    required this.createdAt,
  });

  factory ResultHistoryItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final module = json['module'];
    final course = json['course'];

    return ResultHistoryItemModel(
      id: json['id'] as int,

      moduleTitle:
          json['moduleTitle'] as String? ??
          (module is Map<String, dynamic>
              ? module['title'] as String?
              : null) ??
          'Module',

      courseTitle:
          json['courseTitle'] as String? ??
          (course is Map<String, dynamic>
              ? course['title'] as String?
              : null) ??
          'Course',

      score: json['score'] as int,

      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
    );
  }
}