import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/providers/quiz_provider.dart';
import '../../../../themes/utils.dart';
import '../../model/question_model.dart';
import '../../model/submit_result_model.dart';

/// Arguments passed when navigating into a quiz session.
class QuizSessionArgs {
  final int moduleId;
  final String moduleTitle;

  const QuizSessionArgs({
    required this.moduleId,
    required this.moduleTitle,
  });
}

/// Quiz Session
///
/// - Displays one question at a time.
/// - Allows the learner to select one option.
/// - Does not reveal correctness during the quiz.
/// - Submits all answers together at the end.
/// - Navigates to the results screen after successful submission.
class QuizSessionScreen extends ConsumerStatefulWidget {
  final QuizSessionArgs args;

  const QuizSessionScreen({
    super.key,
    required this.args,
  });

  @override
  ConsumerState<QuizSessionScreen> createState() =>
      _QuizSessionScreenState();
}

class _QuizSessionScreenState
    extends ConsumerState<QuizSessionScreen> {
  int _currentIndex = 0;

  // questionId -> optionId
  final Map<int, int> _selectedOptionByQuestionId = {};

  bool _submitting = false;

  void _selectOption(int questionId, int optionId) {
    setState(() {
      _selectedOptionByQuestionId[questionId] = optionId;
    });
  }

  Future<void> _submit(
    List<QuestionModel> questions,
  ) async {
    setState(() {
      _submitting = true;
    });

    try {
      final repository = ref.read(quizRepositoryProvider);

      final answers = questions.map((question) {
        return SubmitAnswer(
          questionId: question.id,
          optionId: _selectedOptionByQuestionId[question.id]!,
        );
      }).toList();

      final result = await repository.submitAnswers(
        moduleId: widget.args.moduleId,
        answers: answers,
      );

      if (!mounted) return;

      context.pushReplacement(
        AppRoutes.moduleResults,
        extra: result,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submit failed: $e'),
          backgroundColor: errorColor,
        ),
      );

      setState(() {
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(
      quizQuestionsProvider(widget.args.moduleId),
    );

    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(
        child: questionsAsync.when(
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },

          error: (error, stackTrace) {
            return Center(
              child: Text(
                'Failed to load questions: $error',
                style: TextStyle(
                  color: errorColor,
                ),
              ),
            );
          },

          data: (questions) {
            // Prevent a crash if the API returns no questions.
            if (questions.isEmpty) {
              return Center(
                child: Text(
                  'No questions available.',
                  style: TextStyle(
                    color: onSurfaceColor,
                  ),
                ),
              );
            }

            final question = questions[_currentIndex];

            final selectedOptionId =
                _selectedOptionByQuestionId[question.id];

            final isLast =
                _currentIndex == questions.length - 1;

            final canProceed =
                selectedOptionId != null;

            return Column(
              children: [
                // ─────────────────────────────────────
                // Header + progress
                // ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    8,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius:
                            BorderRadius.circular(20),
                        onTap: _submitting
                            ? null
                            : () => context.pop(),
                        child: Icon(
                          Icons.close,
                          color: mutedTextColor,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          widget.args.moduleTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: mutedTextColor,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      Text(
                        'Question '
                        '${_currentIndex + 1} '
                        'of ${questions.length}',
                        style: TextStyle(
                          color: onSurfaceColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) /
                          questions.length,
                      minHeight: 5,
                      backgroundColor: surfaceCards,
                      valueColor:
                          AlwaysStoppedAnimation(
                        actionHighlight,
                      ),
                    ),
                  ),
                ),

                // ─────────────────────────────────────
                // Question + options
                // ─────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.text,
                          style: TextStyle(
                            color: onSurfaceColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 24),

                        ...question.options.map(
                          (option) {
                            final isSelected =
                                selectedOptionId ==
                                    option.id;

                            return Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 12,
                              ),
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.circular(
                                  kCardRadius,
                                ),
                                onTap: _submitting
                                    ? null
                                    : () => _selectOption(
                                          question.id,
                                          option.id,
                                        ),
                                child: Container(
                                  padding:
                                      const EdgeInsets.all(
                                    16,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: isSelected
                                        ? actionHighlight
                                            .withOpacity(0.1)
                                        : surfaceCards,
                                    borderRadius:
                                        BorderRadius.circular(
                                      kCardRadius,
                                    ),
                                    border: Border.all(
                                      color: isSelected
                                          ? actionHighlight
                                          : glossOutline,
                                      width: isSelected
                                          ? 1.5
                                          : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons
                                                .radio_button_checked
                                            : Icons
                                                .radio_button_off,
                                        size: 20,
                                        color: isSelected
                                            ? actionHighlight
                                            : mutedTextColor,
                                      ),

                                      const SizedBox(
                                        width: 12,
                                      ),

                                      Expanded(
                                        child: Text(
                                          option.text,
                                          style: TextStyle(
                                            color:
                                                onSurfaceColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // ─────────────────────────────────────
                // Next / Submit button
                // ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    20,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          !canProceed || _submitting
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
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            kCardRadius,
                          ),
                        ),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              isLast ? 'Submit' : 'Next',
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
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