import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../../../themes/utils.dart';
import '../../model/submit_result_model.dart';

/// Module Results
///
/// Displays the score and percentage after submitting a module.
///
/// NOTE:
/// No per-question breakdown or explanations are shown because
/// that information does not exist in the real backend response.
class ModuleResultsScreen extends StatelessWidget {
  final SubmitResultModel result;

  const ModuleResultsScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    // AIXX platform pass threshold = 80%.
    final passed = result.percentage >= 80;

    final resultColor =
        passed ? successColor : errorColor;

    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ─────────────────────────────────────
              // Percentage Circle
              // ─────────────────────────────────────
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: resultColor.withOpacity(0.1),
                  border: Border.all(
                    color: resultColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${result.percentage.round()}%',
                    style: TextStyle(
                      color: resultColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ─────────────────────────────────────
              // Result Title
              // ─────────────────────────────────────
              Text(
                passed
                    ? 'Module Complete!'
                    : 'Keep Practicing',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: onSurfaceColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              // ─────────────────────────────────────
              // Score
              // ─────────────────────────────────────
              Text(
                'You scored ${result.score} '
                'out of ${result.totalQuestions}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: mutedTextColor,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              // ─────────────────────────────────────
              // Back to Hub
              // ─────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(
                      AppRoutes.dashboard,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: actionHighlight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        kCardRadius,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Back to Hub',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}