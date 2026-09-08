import 'package:flutter/material.dart';

/// Course model — matches the REAL backend schema exactly
/// (Backend_API_Documentation.docx, Section 5: Course table).
/// Real fields: id (Int), title, description, state, createdAt, updatedAt.
/// No category/level/totalQuestions on the backend — those were removed.
/// moduleCount comes from Prisma's `_count: { modules: true }` aggregate
/// on the list endpoint (GET /api/course-cms/courses).
class CourseModel {
  final int id;
  final String title;
  final String description;
  final int moduleCount;
  final IconData icon; // frontend-only, not a backend field

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.moduleCount,
    this.icon = Icons.auto_awesome,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      moduleCount: (json['_count']?['modules'] as int?) ?? 0,
      // icon is never parsed from JSON — assigned locally per course.
    );
  }
}