import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/providers/module_quiz_provider.dart';
import '../../../../themes/utils.dart';
import 'quiz_session_screen.dart' show QuizSessionArgs;

/// Study Material
///
/// Shows the module's reading notes (Markdown) before the quiz.
/// Uses the same moduleContentProvider as the quiz, so the data is
/// fetched once and reused by the Quiz Session screen.
class StudyMaterialScreen extends ConsumerWidget {
  final QuizSessionArgs args;

  const StudyMaterialScreen({super.key, required this.args});

  void _startQuiz(BuildContext context) {
    context.pushReplacement(AppRoutes.quizSession, extra: args);
  }

  MarkdownStyleSheet _markdownStyle() {
    return MarkdownStyleSheet(
      p: TextStyle(color: onSurfaceColor, fontSize: 14, height: 1.6),
      h1: TextStyle(color: onSurfaceColor, fontSize: 22, fontWeight: FontWeight.w700),
      h2: TextStyle(color: onSurfaceColor, fontSize: 19, fontWeight: FontWeight.w700),
      h3: TextStyle(color: onSurfaceColor, fontSize: 17, fontWeight: FontWeight.w700),
      h4: TextStyle(color: onSurfaceColor, fontSize: 15, fontWeight: FontWeight.w600),
      strong: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.w700),
      em: TextStyle(color: onSurfaceColor, fontStyle: FontStyle.italic),
      listBullet: TextStyle(color: actionHighlight, fontSize: 14),
      a: TextStyle(color: actionHighlight),
      blockquote: TextStyle(color: mutedTextColor, fontSize: 14, height: 1.5),
      blockquoteDecoration: BoxDecoration(
        color: surfaceCards,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border(left: BorderSide(color: actionHighlight, width: 3)),
      ),
      code: TextStyle(color: successColor, fontSize: 13),
      codeblockDecoration: BoxDecoration(
        color: surfaceCards,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: glossOutline),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(top: BorderSide(color: glossOutline)),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentAsync = ref.watch(
      moduleContentProvider((
        courseSlug: args.courseSlug,
        moduleIndex: args.moduleIndex,
      )),
    );

    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: canvasBase.withOpacity(0.8),
                border: Border(bottom: BorderSide(color: glossOutline)),
              ),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        shape: BoxShape.circle,
                        border: Border.all(color: glossOutline),
                      ),
                      child: Icon(Icons.arrow_back, size: 20, color: onSurfaceColor),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      args.moduleTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: onSurfaceColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: contentAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Failed to load study material: $error',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: errorColor),
                    ),
                  ),
                ),
                data: (content) {
                  final notes = content.studyNotes;

                  // study_notes can be null (confirmed by backend)
                  if (notes == null || notes.trim().isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.menu_book_outlined, size: 40, color: mutedTextColor),
                            const SizedBox(height: 12),
                            Text(
                              'No study material for this module yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: mutedTextColor, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Markdown(
                    data: notes,
                    padding: const EdgeInsets.all(20),
                    styleSheet: _markdownStyle(),
                  );
                },
              ),
            ),

            // Start Quiz button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // Enabled only once content has loaded successfully
                  onPressed: contentAsync.hasValue ? () => _startQuiz(context) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: actionHighlight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kCardRadius),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Start Quiz', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}