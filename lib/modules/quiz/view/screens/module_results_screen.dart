import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../../../themes/utils.dart';
import '../../model/module_quiz_result_model.dart';
import 'quiz_session_screen.dart' show QuizSessionArgs;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/providers/course_provider.dart';

/// Carries both the result AND the course slug, since the API response
/// alone doesn't include the slug — needed to build "Next Module" nav.
class ModuleResultsArgs {
  final String courseSlug;
  final ModuleQuizSubmitResult result;

  const ModuleResultsArgs({
    required this.courseSlug,
    required this.result,
  });
}

class ModuleResultsScreen extends ConsumerWidget {
  final ModuleResultsArgs args;

  const ModuleResultsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = args.result;
    final resultColor = result.passed ? successColor : errorColor;
    final wrongAnswers = result.results.where((r) => !r.isCorrect).toList();


    // Module titles come from the course contents list Course Contents loaded.
    final modules =
        ref.watch(moduleListProvider(args.courseSlug)).valueOrNull?.modules;

    String titleFor(int moduleIndex) {
      if (modules != null) {
        for (final m in modules) {
          if (m.moduleIndex == moduleIndex) return m.title;
        }
      }
      return 'Module $moduleIndex';
    }

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: actionHighlight,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
    );


    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
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
                result.message,
                textAlign: TextAlign.center,
                style: TextStyle(color: onSurfaceColor, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'You scored ${result.correctCount} out of ${result.totalQuestions}',
                textAlign: TextAlign.center,
                style: TextStyle(color: mutedTextColor, fontSize: 15),
              ),

              if (wrongAnswers.isNotEmpty) ...[
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'What to review',
                    style: TextStyle(color: onSurfaceColor, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                ...wrongAnswers.map((item) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceCards,
                        borderRadius: BorderRadius.circular(kCardRadius),
                        border: Border.all(color: errorColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        item.explanation ?? 'No explanation provided.',
                        style: TextStyle(color: mutedTextColor, fontSize: 13, height: 1.4),
                      ),
                    )),
              ],

              const SizedBox(height: 40),

                            if (result.passed &&
                  result.nextModule != null &&
                  result.nextModule!.unlocked)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushReplacement(
                        AppRoutes.studyMaterial,
                        extra: QuizSessionArgs(
                          courseSlug: args.courseSlug,
                          moduleIndex: result.nextModule!.moduleIndex,
                          moduleTitle:
                              titleFor(result.nextModule!.moduleIndex),
                        ),
                      );
                    },
                    style: buttonStyle,
                    child: const Text(
                      'Next Module',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              else if (!result.passed) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // Restart this module from its study material.
                    onPressed: () => context.pushReplacement(
                      AppRoutes.studyMaterial,
                      extra: QuizSessionArgs(
                        courseSlug: args.courseSlug,
                        moduleIndex: result.moduleIndex,
                        moduleTitle: titleFor(result.moduleIndex),
                      ),
                    ),
                    style: buttonStyle,
                    child: const Text(
                      'Try Again',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.go(AppRoutes.dashboard),
                  child: Text(
                    'Back to Hub',
                    style: TextStyle(color: mutedTextColor),
                  ),
                ),
              ] else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go(AppRoutes.dashboard),
                    style: buttonStyle,
                    child: const Text(
                      'Back to Hub',
                      style: TextStyle(fontWeight: FontWeight.w600),
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