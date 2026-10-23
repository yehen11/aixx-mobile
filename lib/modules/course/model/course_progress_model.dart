class CourseProgress {
  final int id;
  final String name;
  final String slug;
  final int totalModules;
  final int completedModulesCount;
  final String progressCounter;
  final int progressPercentage;
  final bool isAllCompleted;

  CourseProgress({
    required this.id,
    required this.name,
    required this.slug,
    required this.totalModules,
    required this.completedModulesCount,
    required this.progressCounter,
    required this.progressPercentage,
    required this.isAllCompleted,
  });

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      totalModules: (json['total_modules'] as num).toInt(),
      completedModulesCount: (json['completed_modules_count'] as num).toInt(),
      progressCounter: json['progress_counter'] as String,
      progressPercentage: (json['progress_percentage'] as num).toInt(),
      isAllCompleted: json['is_all_completed'] as bool,
    );
  }
}