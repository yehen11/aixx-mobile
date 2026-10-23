import 'package:flutter/material.dart';
import '../../../../services/core/api_client.dart';
import '../../model/course_model.dart';
import '../../model/course_progress_model.dart';
import '../../model/module_model.dart';
import '../../../../config/app_config.dart';

/// Course API — supports both mock data (now) and the real backend,
/// controlled by [kUseMockCourseData].
///
/// Confirmed real endpoints (27/09/2026):
///   GET /api/courses                  (public, no auth needed)
///   GET /api/courses/{slug}/contents  (lists modules + progress, ordered by module_index)
///
/// NOTE: /api/course-cms/courses is admin-only and must never be used here.
const bool kUseMockCourseData = useTestMode;

class CourseApi {
  Future<List<CourseModel>> getCourses() async {
    if (kUseMockCourseData) {
      await Future.delayed(const Duration(milliseconds: 400));
      return [
        CourseModel(
          id: 1,
          slug: 'general-ai-knowledge-for-everyday-life',
          title: 'General AI Knowledge for Everyday Life',
          description:
              'The free foundation course covering AI basics, everyday AI tools, '
              'using AI responsibly, and how AI is changing work and life.',
          subTitle: 'Foundation course',
          isFree: true,
          badges: const ['Free', 'Foundation'],
          modulesCount: 5,
          totalMcqsCount: 150,
          highlights: const ['AI basics', 'Everyday AI tools', 'Responsible AI use'],
          thumbnailUrl: null,
          icon: Icons.auto_awesome,
        ),
      ];
    }

    // Public endpoint — no auth required.
    final response = await ApiClient.dio.get('/courses');
    final List data = response.data['data'] as List;
    return data.map((json) => CourseModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<({CourseProgress progress, List<ModuleModel> modules})> getModules(
    String courseSlug,
  ) async {
    if (kUseMockCourseData) {
      await Future.delayed(const Duration(milliseconds: 300));

      const titles = [
        'Module 1: AI Basics',
        'Module 2: AI in Everyday Life',
        'Module 3: Using AI Tools',
        'Module 4: AI, Work and the Future',
        'Module 5: Safe & Responsible AI',
      ];

      return (
        progress: CourseProgress(
          id: 1,
          name: 'General AI Knowledge for Everyday Life',
          slug: courseSlug,
          totalModules: 5,
          completedModulesCount: 0,
          progressCounter: '0/5 Completed',
          progressPercentage: 0,
          isAllCompleted: false,
        ),
        modules: List.generate(5, (i) {
          return ModuleModel(
            id: i + 1,
            moduleIndex: i + 1,
            title: titles[i],
            studyNotes: null,
            questionsCount: 6,
            status: 'Available',
            isCompleted: false,
            score: null,
            passed: false,
            actionUrl: '/courses/$courseSlug/modules/${i + 1}',
          );
        }),
      );
    }

    final response = await ApiClient.dio.get('/courses/$courseSlug/contents');
    final data = response.data as Map<String, dynamic>;

    return (
      progress: CourseProgress.fromJson(data['course'] as Map<String, dynamic>),
      modules: (data['modules'] as List)
          .map((m) => ModuleModel.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}