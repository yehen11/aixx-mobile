class ModuleQuizQuestion {
  final int id;
  final int questionIndex;
  final String question;
  final Map<String, String> options;

  ModuleQuizQuestion({
    required this.id,
    required this.questionIndex,
    required this.question,
    required this.options,
  });

  factory ModuleQuizQuestion.fromJson(Map<String, dynamic> json) {
    return ModuleQuizQuestion(
      id: json['id'] as int,
      questionIndex: json['question_index'] as int,
      question: json['question'] as String,
      options: Map<String, String>.from(json['options'] as Map),
    );
  }
}

class ModuleQuizContent {
  final bool success;
  final String courseSlug;
  final String courseName;
  final int moduleIndex;
  final String title;
  final String? studyNotes;
  final int totalQuestions;
  final List<ModuleQuizQuestion> questions;
  final String submitUrl;

  ModuleQuizContent({
    required this.success,
    required this.courseSlug,
    required this.courseName,
    required this.moduleIndex,
    required this.title,
    this.studyNotes,
    required this.totalQuestions,
    required this.questions,
    required this.submitUrl,
  });

  factory ModuleQuizContent.fromJson(Map<String, dynamic> json) {
    return ModuleQuizContent(
      success: json['success'] as bool,
      courseSlug: json['course_slug'] as String,
      courseName: json['course_name'] as String,
      moduleIndex: json['module_index'] as int,
      title: json['title'] as String,
      studyNotes: json['study_notes'] as String?,
      totalQuestions: json['total_questions'] as int,
      questions: (json['questions'] as List)
          .map((q) => ModuleQuizQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
      submitUrl: json['submit_url'] as String,
    );
  }
}