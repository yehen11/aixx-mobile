import 'package:flutter/material.dart';
import '../../../../services/core/api_client.dart';
import '../../model/course_model.dart';
import '../../model/module_model.dart';

/// Course API — supports both mock data (now) and the real backend
/// (once hosted), controlled by [kUseMockCourseData].
///
/// Real endpoints, per Backend_API_Documentation.docx Section 3.3:
///   GET /api/course-cms/courses      (Bearer JWT required)
///   GET /api/course-cms/courses/:id  (Bearer JWT required)
const bool kUseMockCourseData = true;

class CourseApi {
  Future<List<CourseModel>> getCourses() async {
    if (kUseMockCourseData) {
      await Future.delayed(const Duration(milliseconds: 400));
      return [
        CourseModel(
          id: 1,
          title: 'General AI Knowledge for Everyday Life',
          description:
              'The free foundation course covering AI basics, everyday AI tools, '
              'using AI responsibly, and how AI is changing work and life.',
          moduleCount: 5,
          icon: Icons.auto_awesome,
        ),
      ];
    }

    // Real API call — requires a valid saved token (see TokenStorage).
    final response = await ApiClient.dio.get('/api/course-cms/courses');
    final List data = response.data as List;
    return data.map((json) => CourseModel.fromJson(json)).toList();
  }

  Future<List<ModuleModel>> getModules(int courseId) async {
    if (kUseMockCourseData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return [
        ModuleModel(id: 1, courseId: courseId, title: 'AI Basics', description: ''),
        ModuleModel(id: 2, courseId: courseId, title: 'AI in Everyday Life', description: ''),
        ModuleModel(id: 3, courseId: courseId, title: 'Using AI Tools', description: ''),
        ModuleModel(id: 4, courseId: courseId, title: 'AI, Work and the Future', description: ''),
        ModuleModel(id: 5, courseId: courseId, title: 'Safe & Responsible AI', description: ''),
      ];
    }

    // Real API returns the course object with a nested "modules" array
    // (per Section 3.3: "includes child Module records").
    final response = await ApiClient.dio.get('/api/course-cms/courses/$courseId');
    final List modules = response.data['modules'] as List;
    return modules.map((json) => ModuleModel.fromJson(json)).toList();
  }
}