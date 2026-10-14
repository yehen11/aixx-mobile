import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/providers/quiz_provider.dart';
import '../../../../themes/utils.dart';
import '../../model/attempt_model.dart';
import '../../model/complete_result_model.dart';
import 'final_assessment_results_screen.dart' show FinalAssessmentResultsArgs;

/// Arguments for the course-level final assessment.
/// training_id == course id (confirmed by backend).
class FinalAssessmentArgs {
  final int courseId;
  final String courseSlug;
  final String courseTitle;

  const FinalAssessmentArgs({
    required this.courseId,
    required this.courseSlug,
    required this.courseTitle,
  });
}

class FinalAssessmentScreen extends ConsumerStatefulWidget {
  final FinalAssessmentArgs args;

  const FinalAssessmentScreen({super.key, required this.args});

  @override
  ConsumerState<FinalAssessmentScreen> createState() => _FinalAssessmentScreenState();
}

class _FinalAssessmentScreenState extends ConsumerState<FinalAssessmentScreen> {
  StartAttemptResponse? _attempt;
  bool _loading = true;
  String? _error;

  // Set when the backend answers 409 ALREADY_PASSED.
  bool _alreadyPassed = false;

  int _currentIndex = 0;

  // attemptQuestionId -> option key the student has chosen on screen
  final Map<int, String> _selected = {};

  // attemptQuestionId -> option key the server already has saved
  final Map<int, String> _saved = {};

  // true while saving an answer or completing the attempt
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _retry() {
    setState(() {
      _loading = true;
      _error = null;
    });
    _start();
  }

  /// Resume may return the saved answer as the option key ("B") or its text.
  /// Accept either and normalise to the key.
  String? _resolveKey(AttemptQuestion q) {
    final saved = q.selectedOption;
    if (saved == null) return null;
    if (q.options.containsKey(saved)) return saved;
    for (final entry in q.options.entries) {
      if (entry.value == saved) return entry.key;
    }
    return null;
  }

  String _messageFrom(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return 'Something went wrong. Please check your connection and try again.';
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: errorColor),
    );
  }

  Future<void> _start() async {
    try {
      final repository = ref.read(quizRepositoryProvider);

      // 201 = new attempt, 200 = resumed unfinished attempt.
      final response = await repository.startAttempt(trainingId: widget.args.courseId);
      final attempt = StartAttemptResponse.fromJson(response.data as Map<String, dynamic>);

      if (!mounted) return;

      if (attempt.questions.isEmpty) {
        setState(() {
          _error = 'No questions available.';
          _loading = false;
        });
        return;
      }

      _selected.clear();
      _saved.clear();

      for (final q in attempt.questions) {
        final key = _resolveKey(q);
        if (key != null) {
          _selected[q.attemptQuestionId] = key;
          _saved[q.attemptQuestionId] = key;
        }
      }

      // Jump to the first unanswered question (or the last one if all are answered).
      var index = attempt.questions.indexWhere(
        (q) => !_saved.containsKey(q.attemptQuestionId),
      );
      if (index == -1) index = attempt.questions.length - 1;

      setState(() {
        _attempt = attempt;
        _currentIndex = index;
        _loading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;

      if (e.response?.statusCode == 409 && data is Map && data['code'] == 'ALREADY_PASSED') {
        setState(() {
          _alreadyPassed = true;
          _loading = false;
        });
        return;
      }

      setState(() {
        _error = _messageFrom(e);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Could not load the assessment: $e';
        _loading = false;
      });
    }
  }

  Future<void> _next() async {
    final attempt = _attempt!;
    final question = attempt.questions[_currentIndex];
    final questionId = question.attemptQuestionId;
    final choice = _selected[questionId];

    if (choice == null || _busy) return;

    setState(() {
      _busy = true;
    });

    try {
      final repository = ref.read(quizRepositoryProvider);

      // One answer per question, sent as the student moves on.
      // Skipped if the server already has this exact answer (e.g. after resume).
      if (_saved[questionId] != choice) {
        await repository.submitAnswer(
          attemptId: attempt.attemptId,
          attemptQuestionId: questionId,
          selectedOption: choice,
        );
        _saved[questionId] = choice;
      }

      final isLast = _currentIndex == attempt.questions.length - 1;

      if (!isLast) {
        if (!mounted) return;
        setState(() {
          _currentIndex++;
          _busy = false;
        });
        return;
      }

      final response = await repository.completeAttempt(attempt.attemptId);
      final result = CompleteResultModel.fromJson(response.data as Map<String, dynamic>);

      if (!mounted) return;

      context.pushReplacement(
        AppRoutes.finalAssessmentResults,
        extra: FinalAssessmentResultsArgs(
          assessment: widget.args,
          result: result,
        ),
      );
    } on DioException catch (e) {
      if (!mounted) return;
      _showError(_messageFrom(e));
      setState(() {
        _busy = false;
      });
    } catch (e) {
      if (!mounted) return;
      _showError('Something went wrong: $e');
      setState(() {
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Preparing your assessment...', style: TextStyle(color: mutedTextColor, fontSize: 14)),
          ],
        ),
      );
    }

    if (_alreadyPassed) return _buildAlreadyPassed();
    if (_error != null) return _buildError();

    return _buildQuiz();
  }

  Widget _buildAlreadyPassed() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium_outlined, size: 56, color: successColor),
            const SizedBox(height: 16),
            Text(
              'You\'ve already passed',
              textAlign: TextAlign.center,
              style: TextStyle(color: onSurfaceColor, fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'You passed the final assessment for ${widget.args.courseTitle}. Your certificate is ready.',
              textAlign: TextAlign.center,
              style: TextStyle(color: mutedTextColor, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // TODO: pass _certificateId to the Certificate screen once it is built.
                onPressed: () => context.go(AppRoutes.certificates),
                style: _primaryButtonStyle(),
                child: const Text('View Certificate', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.pop(),
                style: _secondaryButtonStyle(),
                child: Text('Back to Course', style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: errorColor),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: errorColor, fontSize: 14)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _retry,
                style: _primaryButtonStyle(),
                child: const Text('Try Again', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.pop(),
                style: _secondaryButtonStyle(),
                child: Text('Back', style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuiz() {
    final attempt = _attempt!;
    final questions = attempt.questions;
    final question = questions[_currentIndex];
    final selectedKey = _selected[question.attemptQuestionId];
    final isLast = _currentIndex == questions.length - 1;
    final canProceed = selectedKey != null && !_busy;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _busy ? null : () => context.pop(),
                child: Icon(Icons.close, color: mutedTextColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Final Assessment',
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
        if (attempt.isResumed)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Resumed from your previous attempt',
                style: TextStyle(color: mutedTextColor, fontSize: 11),
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
                  final isSelected = selectedKey == entry.key;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(kCardRadius),
                      onTap: _busy
                          ? null
                          : () {
                              setState(() {
                                _selected[question.attemptQuestionId] = entry.key;
                              });
                            },
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
                              child: Text(entry.value, style: TextStyle(color: onSurfaceColor, fontSize: 14)),
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
              onPressed: canProceed ? _next : null,
              style: _primaryButtonStyle(),
              child: _busy
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                    )
                  : Text(isLast ? 'Finish' : 'Next', style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
    );
  }

  ButtonStyle _primaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: actionHighlight,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
    );
  }

  ButtonStyle _secondaryButtonStyle() {
    return OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14),
      side: BorderSide(color: glossOutline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
    );
  }
}