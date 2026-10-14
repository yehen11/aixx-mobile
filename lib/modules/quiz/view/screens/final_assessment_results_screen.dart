import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../../../themes/utils.dart';
import '../../model/complete_result_model.dart';
import 'final_assessment_screen.dart' show FinalAssessmentArgs;

/// Carries the course info (for "Try Again") together with the graded result.
class FinalAssessmentResultsArgs {
  final FinalAssessmentArgs assessment;
  final CompleteResultModel result;

  const FinalAssessmentResultsArgs({
    required this.assessment,
    required this.result,
  });
}

class FinalAssessmentResultsScreen extends StatelessWidget {
  final FinalAssessmentResultsArgs args;

  const FinalAssessmentResultsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final result = args.result;
    final passed = result.passed;
    final resultColor = passed ? successColor : errorColor;
    final mistakes = result.questionBreakdown.where((q) => !q.isCorrect).toList();

    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: resultColor.withOpacity(0.1),
                  border: Border.all(color: resultColor.withOpacity(0.3), width: 2),
                ),
                child: Center(
                  child: Text(
                    '${result.score.round()}%',
                    style: TextStyle(color: resultColor, fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                passed ? 'Assessment Passed!' : 'Not Quite There Yet',
                textAlign: TextAlign.center,
                style: TextStyle(color: onSurfaceColor, fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'You answered ${result.correctCount} of ${result.totalQuestions} correctly',
                textAlign: TextAlign.center,
                style: TextStyle(color: mutedTextColor, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                '80% is required to pass',
                textAlign: TextAlign.center,
                style: TextStyle(color: mutedTextColor, fontSize: 12),
              ),

              if (passed) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceCards,
                    borderRadius: BorderRadius.circular(kCardRadius),
                    border: Border.all(color: successColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.workspace_premium_outlined, size: 32, color: successColor),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Certificate issued',
                              style: TextStyle(color: onSurfaceColor, fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Your certificate for ${args.assessment.courseTitle} is ready.',
                              style: TextStyle(color: mutedTextColor, fontSize: 12, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (mistakes.isNotEmpty) ...[
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Review your mistakes',
                    style: TextStyle(color: onSurfaceColor, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                ...mistakes.map(
                  (item) => Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceCards,
                      borderRadius: BorderRadius.circular(kCardRadius),
                      border: Border.all(color: errorColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.questionText,
                          style: TextStyle(color: onSurfaceColor, fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your answer: ${item.selectedOption}',
                          style: TextStyle(color: mutedTextColor, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: errorColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.warning_amber_rounded, size: 18, color: errorColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.consequenceText ?? 'No consequence details provided.',
                                  style: TextStyle(color: onSurfaceColor, fontSize: 13, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (passed) {
                      // TODO: pass result.certificateId to the Certificate screen once it is built.
                      context.go(AppRoutes.certificates);
                    } else {
                      context.pushReplacement(AppRoutes.finalAssessment, extra: args.assessment);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: actionHighlight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
                  ),
                  child: Text(
                    passed ? 'View Certificate' : 'Try Again',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: glossOutline),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
                  ),
                  child: Text('Back to Course', style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}