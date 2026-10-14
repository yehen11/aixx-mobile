/// Response from POST /assessment/attempts.
/// 201 = new attempt, 200 = resumed unfinished attempt (is_resumed: true).
class AttemptQuestion {
  final int attemptQuestionId;
  final String question;
  final Map<String, String> options; // {"A": "...", "B": "...", ...}
  final String? selectedOption; // option KEY saved earlier, when resuming

  AttemptQuestion({
    required this.attemptQuestionId,
    required this.question,
    required this.options,
    required this.selectedOption,
  });

  factory AttemptQuestion.fromJson(Map<String, dynamic> json) {
    return AttemptQuestion(
      attemptQuestionId: json['attempt_question_id'] as int,
      question: json['question'] as String,
      options: Map<String, String>.from(json['options'] as Map),
      selectedOption: json['selected_option'] as String?,
    );
  }
}

class StartAttemptResponse {
  final int attemptId;
  final bool isResumed;
  final List<AttemptQuestion> questions;

  StartAttemptResponse({
    required this.attemptId,
    required this.isResumed,
    required this.questions,
  });

  factory StartAttemptResponse.fromJson(Map<String, dynamic> json) {
    return StartAttemptResponse(
      attemptId: json['attempt_id'] as int,
      isResumed: json['is_resumed'] as bool? ?? false,
      questions: (json['questions'] as List)
          .map((q) => AttemptQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}