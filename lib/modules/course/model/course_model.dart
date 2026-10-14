import 'package:flutter/material.dart';

/// Course model — matches GET /api/courses (public, confirmed 27/09/2026).
class CourseModel {
  final int id;
  final String slug;
  final String title;
  final String description;
  final String subTitle;
  final bool isFree;
  final List<String> badges;
  final int modulesCount;
  final int totalMcqsCount;
  final List<String> highlights;
  final String? thumbnailUrl;
  final IconData icon; // frontend-only, not a backend field

  CourseModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.subTitle,
    required this.isFree,
    required this.badges,
    required this.modulesCount,
    required this.totalMcqsCount,
    required this.highlights,
    required this.thumbnailUrl,
    this.icon = Icons.auto_awesome,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      subTitle: json['sub_title'] as String? ?? '',
      isFree: json['is_free'] as bool? ?? false,
      badges: (json['badges'] as List?)?.map((b) => b as String).toList() ?? [],
      modulesCount: json['modules_count'] as int? ?? 0,
      totalMcqsCount: json['total_mcqs_count'] as int? ?? 0,
      highlights: (json['highlights'] as List?)?.map((h) => h as String).toList() ?? [],
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }
}