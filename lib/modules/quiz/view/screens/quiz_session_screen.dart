import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/providers/module_quiz_provider.dart';
import '../../../../themes/utils.dart';
import '../../model/module_quiz_content_model.dart';
import 'module_results_screen.dart' show ModuleResultsArgs;

class QuizSessionArgs {
  final String courseSlug;
  final int moduleIndex;
  final String moduleTitle;

  const QuizSessionArgs({
    required this.courseSlug,
    required this.moduleIndex,
    required this.moduleTitle,
  });
}

class QuizSessionScreen extends ConsumerStatefulWidget {
  final QuizSessionArgs args;

  const QuizSessionScreen({super.key, required this.args});

  @override
  ConsumerState<QuizSessionScreen> createState() => _QuizSessionScreenState();
}

class _QuizSessionScreenState extends ConsumerState<QuizSessionScreen> {
  int _currentIndex = 0;

  // questionId -> selected option letter ("A", "B", "C", "D")
  final Map<int, String> _selectedOptionByQuestionId = {};

  bool _submitting = false;

  void _selectOption(int questionId, String optionKey) {
    setState(() {
      _selectedOptionByQuestionId[questionId] = optionKey;
    });
  }

  Future<void> _submit(List<ModuleQuizQuestion> questions) async {
    setState(() {
      _submitting = true;
    });

    try {
      final repository = ref.read(moduleQuizRepositoryProvider);

      final answers = <int, String>{
        for (final q in questions) q.id: _selectedOptionByQuestionId[q.id]!,
      };

      final result = await repository.submitAnswers(
        courseSlug: widget.args.courseSlug,
        moduleIndex: widget.args.moduleIndex,
        answers: answers,
      );

      if (!mounted) return;

      context.pushReplacement(
        AppRoutes.moduleResults,
        extra: ModuleResultsArgs(
          courseSlug: widget.args.courseSlug,
          result: result,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submit failed: $e'), backgroundColor: errorColor),
      );

      setState(() {
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentAsync = ref.watch(
      moduleContentProvider((
        courseSlug: widget.args.courseSlug,
        moduleIndex: widget.args.moduleIndex,
      )),
    );

    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(
        child: contentAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text('Failed to load quiz: $error', style: TextStyle(color: errorColor)),
          ),
          data: (content) {
            final questions = content.questions;

            if (questions.isEmpty) {
              return Center(
                child: Text('No questions available.', style: TextStyle(color: onSurfaceColor)),
              );
            }

            final question = questions[_currentIndex];
            final selectedOption = _selectedOptionByQuestionId[question.id];
            final isLast = _currentIndex == questions.length - 1;
            final canProceed = selectedOption != null;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: _submitting ? null : () => context.pop(),
                        child: Icon(Icons.close, color: mutedTextColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.args.moduleTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: mutedTextColor, fontSize: 13),
                        ),
                      ),
                      Text(
                        'Question ${_currentIndex + 1} of ${questions.length}',
                        style: TextStyle(color: onSurfaceColor, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / questions.length,
                      minHeight: 5,
                      backgroundColor: surfaceCards,
                      valueColor: AlwaysStoppedAnimation(actionHighlight),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.question,
                          style: TextStyle(color: onSurfaceColor, fontSize: 18, fontWeight: FontWeight.w600, height: 1.4),
                        ),
                        const SizedBox(height: 24),
                        ...question.options.entries.map((entry) {
                          final optionKey = entry.key;
                          final optionText = entry.value;
                          final isSelected = selectedOption == optionKey;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(kCardRadius),
                              onTap: _submitting ? null : () => _selectOption(question.id, optionKey),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected ? actionHighlight.withOpacity(0.1) : surfaceCards,
                                  borderRadius: BorderRadius.circular(kCardRadius),
                                  border: Border.all(
                                    color: isSelected ? actionHighlight : glossOutline,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                      size: 20,
                                      color: isSelected ? actionHighlight : mutedTextColor,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(optionText, style: TextStyle(color: onSurfaceColor, fontSize: 14)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: !canProceed || _submitting
                          ? null
                          : () {
                              if (isLast) {
                                _submit(questions);
                              } else {
                                setState(() {
                                  _currentIndex++;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: actionHighlight,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              height: 20, width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                            )
                          : Text(isLast ? 'Submit' : 'Next', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}