import 'package:dio/dio.dart';

/// Attempt-based assessment API, per AIXX_Mobile_App_API_Routes.docx.
/// Replaces the old batch-fetch/batch-submit approach entirely.
abstract class IQuizApi {
  /// POST /assessment/attempts
  /// Starts (or resumes) an attempt. Pass exactly one of trainingId/trainingSlug.
  Future<Response> startAttempt({int? trainingId, String? trainingSlug});

  /// POST /assessment/attempts/{id}/answers
  /// Submits ONE answer immediately as the user picks it — not batched.
  /// selectedOption is currently sent as the option KEY (e.g. "A") per the
  /// routes doc — confirm this against a real request before shipping.
  Future<Response> submitAnswer({
    required int attemptId,
    required int attemptQuestionId,
    required String selectedOption,
  });

  /// POST /assessment/attempts/{id}/complete
  /// Grades the attempt and returns score + question_breakdown.
  Future<Response> completeAttempt(int attemptId);
}