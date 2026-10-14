import '../../model/module_quiz_content_model.dart';
import '../../model/module_quiz_result_model.dart';
import 'i_module_quiz_api.dart';

class MockModuleQuizApi implements IModuleQuizApi {
  // Each module: title, study notes, and a themed question bank with
  // the correct answer key so submitAnswers can grade realistically.
  static final _modules = <int, _MockModuleData>{
    1: _MockModuleData(
      title: 'Module 1: AI Basics',
      studyNotes: '''
### What is Artificial Intelligence?

AI refers to computer systems that can perform tasks normally requiring human intelligence — recognizing patterns, making predictions, and generating content.

**Key terms to know:**
- **Machine Learning (ML):** systems that improve at a task by learning from data, rather than following fixed rules
- **Large Language Model (LLM):** an AI trained on huge amounts of text, used for tools like chatbots
- **Generative AI:** AI that creates new content — text, images, audio — rather than just analyzing existing data

> AI doesn't "think" the way humans do. It finds patterns in data and predicts the most likely next output.

Understanding these basics is the foundation for using AI tools safely and effectively in the next modules.
''',
      questions: [
        _MockQuestion(
          text: 'Which best describes Machine Learning?',
          options: {
            'A': 'A system that follows only fixed, hand-written rules',
            'B': 'A system that improves at a task by learning from data',
            'C': 'A type of computer hardware',
            'D': 'A programming language',
          },
          correct: 'B',
          wrongExplanation: 'Machine Learning systems improve through exposure to data, not fixed rules — that distinction is what separates ML from traditional software.',
        ),
        _MockQuestion(
          text: 'What is a Large Language Model (LLM) primarily trained on?',
          options: {
            'A': 'Images only',
            'B': 'Audio recordings',
            'C': 'Large amounts of text',
            'D': 'Spreadsheet data only',
          },
          correct: 'C',
          wrongExplanation: 'LLMs like the ones powering chatbots are trained primarily on large volumes of text data to learn language patterns.',
        ),
        _MockQuestion(
          text: 'Generative AI is best described as AI that:',
          options: {
            'A': 'Only analyzes existing data',
            'B': 'Creates new content such as text or images',
            'C': 'Only works with numbers',
            'D': 'Requires no training data',
          },
          correct: 'B',
          wrongExplanation: 'Generative AI is specifically defined by its ability to produce new content, not just analyze what already exists.',
        ),
        _MockQuestion(
          text: 'True or false: AI "thinks" the same way humans do.',
          options: {
            'A': 'True — AI reasons exactly like a human brain',
            'B': 'False — AI finds patterns in data to predict outputs',
            'C': 'True, but only for generative AI',
            'D': 'AI does not process information at all',
          },
          correct: 'B',
          wrongExplanation: 'AI systems predict likely outputs based on patterns in training data — a fundamentally different process from human reasoning.',
        ),
      ],
    ),
    2: _MockModuleData(
      title: 'Module 2: AI in Everyday Life',
      studyNotes: '''
### Where AI Already Shows Up

AI is already woven into tools people use daily, often without realizing it:

- **Recommendation systems** — streaming services suggesting what to watch next
- **Navigation apps** — predicting the fastest route using live traffic data
- **Email filtering** — automatically sorting spam from your inbox
- **Voice assistants** — understanding spoken requests and responding

**Why this matters:** recognizing where AI is already at work helps you understand both its usefulness and its limits — these systems are good at pattern-matching, but can still make mistakes or reflect biases in their training data.
''',
      questions: [
        _MockQuestion(
          text: 'Which of these is a common everyday use of AI?',
          options: {
            'A': 'Streaming service recommendations',
            'B': 'A printed newspaper',
            'C': 'A mechanical calculator',
            'D': 'A handwritten letter',
          },
          correct: 'A',
          wrongExplanation: 'Recommendation systems on streaming platforms are a classic, widely-used example of AI operating in daily life.',
        ),
        _MockQuestion(
          text: 'How do navigation apps typically use AI?',
          options: {
            'A': 'By printing paper maps',
            'B': 'By predicting routes using live traffic data',
            'C': 'By disabling GPS',
            'D': 'By only working offline',
          },
          correct: 'B',
          wrongExplanation: 'Navigation apps use AI to process live traffic data and predict the fastest available route in real time.',
        ),
        _MockQuestion(
          text: 'Why is it useful to recognize where AI already shows up in daily tools?',
          options: {
            'A': 'It has no practical benefit',
            'B': 'It helps you understand both AI\'s usefulness and its limits',
            'C': 'It guarantees the AI is always correct',
            'D': 'It removes the need to ever question AI output',
          },
          correct: 'B',
          wrongExplanation: 'Recognizing everyday AI use helps build a balanced view — understanding where it helps, and where it can still make mistakes.',
        ),
      ],
    ),
    3: _MockModuleData(
      title: 'Module 3: Using AI Tools',
      studyNotes: '''
### Getting Useful Results From AI Tools

The quality of AI output depends heavily on how you ask. This is often called **prompting**.

**Good prompting habits:**
1. Be specific about what you want and the format you need
2. Give context — background info the AI wouldn't otherwise know
3. Ask for one task at a time rather than many at once
4. Review and verify the output — don't assume it's correct

**Common mistake:** treating AI output as a finished, verified answer rather than a draft that still needs a human review step.
''',
      questions: [
        _MockQuestion(
          text: 'What is "prompting" in the context of AI tools?',
          options: {
            'A': 'Installing the AI software',
            'B': 'How you phrase your request to the AI',
            'C': 'Turning off the AI tool',
            'D': 'The AI\'s internal programming language',
          },
          correct: 'B',
          wrongExplanation: 'Prompting refers to how a request is phrased — specificity and context strongly affect the quality of the AI\'s response.',
        ),
        _MockQuestion(
          text: 'Which is a good prompting habit?',
          options: {
            'A': 'Asking several unrelated tasks in one vague prompt',
            'B': 'Giving no context at all',
            'C': 'Being specific about the format and goal',
            'D': 'Never reviewing the output',
          },
          correct: 'C',
          wrongExplanation: 'Specific, well-scoped prompts with clear context consistently produce more useful AI output.',
        ),
        _MockQuestion(
          text: 'What\'s the safest way to treat AI-generated output?',
          options: {
            'A': 'As a finished, fully verified answer',
            'B': 'As a draft that still needs human review',
            'C': 'As always factually correct',
            'D': 'As something that never needs checking',
          },
          correct: 'B',
          wrongExplanation: 'AI output should be treated as a starting draft — human review remains essential to catch errors before relying on it.',
        ),
      ],
    ),
    4: _MockModuleData(
      title: 'Module 4: AI, Work and the Future',
      studyNotes: '''
### How AI Is Changing Work

AI is reshaping jobs rather than simply eliminating them wholesale. Common patterns include:

- **Task automation** — repetitive, rules-based tasks being handled by AI
- **Augmentation** — AI assisting a person rather than replacing them (e.g. drafting, summarizing)
- **New roles emerging** — jobs focused on managing, reviewing, and directing AI tools

**A balanced view:** the skills most valuable going forward are often the ones AI is weakest at — judgment, context, ethics, and relationship-building.
''',
      questions: [
        _MockQuestion(
          text: 'What does "augmentation" mean in the context of AI and work?',
          options: {
            'A': 'AI fully replacing a worker',
            'B': 'AI assisting a person rather than replacing them',
            'C': 'Removing all technology from the workplace',
            'D': 'A type of salary increase',
          },
          correct: 'B',
          wrongExplanation: 'Augmentation describes AI supporting human work — like drafting or summarizing — rather than eliminating the role entirely.',
        ),
        _MockQuestion(
          text: 'Which skills tend to remain valuable as AI use grows?',
          options: {
            'A': 'Skills AI already performs perfectly',
            'B': 'Judgment, context, and ethical decision-making',
            'C': 'Only technical AI programming skills',
            'D': 'None — all skills become obsolete',
          },
          correct: 'B',
          wrongExplanation: 'Human judgment, contextual understanding, and ethics remain areas where AI is comparatively weak, keeping these skills valuable.',
        ),
        _MockQuestion(
          text: 'What kind of new roles are emerging due to AI adoption?',
          options: {
            'A': 'Roles focused on managing and reviewing AI tools',
            'B': 'No new roles are being created',
            'C': 'Only roles that avoid technology entirely',
            'D': 'Roles that require no human oversight',
          },
          correct: 'A',
          wrongExplanation: 'As AI tools spread, new roles are emerging specifically around directing, reviewing, and governing their use.',
        ),
      ],
    ),
    5: _MockModuleData(
      title: 'Module 5: Safe & Responsible AI',
      studyNotes: '''
### Using AI Responsibly

As AI becomes part of daily workflows, responsible use matters as much as technical skill.

**Core principles:**
- **Privacy:** never input sensitive personal or confidential company data into public AI tools
- **Verification:** AI can produce confident-sounding but incorrect answers ("hallucinations") — always verify facts
- **Bias awareness:** AI systems can reflect biases present in their training data
- **Compliance:** follow your organization's policies on approved AI tools and data handling

**Remember:** responsible AI use protects both the individual and the organization from real-world harm — financial, legal, and reputational.
''',
      questions: [
        _MockQuestion(
          text: 'What does it mean when an AI "hallucinates"?',
          options: {
            'A': 'The AI crashes and stops working',
            'B': 'The AI produces confident-sounding but incorrect information',
            'C': 'The AI refuses to answer',
            'D': 'The AI asks a clarifying question',
          },
          correct: 'B',
          wrongExplanation: 'Hallucination refers to AI confidently generating information that sounds plausible but is factually wrong — always worth verifying.',
        ),
        _MockQuestion(
          text: 'What should you avoid entering into public AI tools?',
          options: {
            'A': 'General knowledge questions',
            'B': 'Sensitive personal or confidential company data',
            'C': 'Publicly available information',
            'D': 'Grammar questions',
          },
          correct: 'B',
          wrongExplanation: 'Entering sensitive or confidential data into public AI tools risks data exposure — this is one of the most common compliance violations.',
        ),
        _MockQuestion(
          text: 'Why does bias awareness matter when using AI?',
          options: {
            'A': 'AI systems can reflect biases present in their training data',
            'B': 'AI is never biased',
            'C': 'Bias only affects older AI systems',
            'D': 'Bias is not a relevant concept for AI',
          },
          correct: 'A',
          wrongExplanation: 'AI models learn from data that can contain human biases, which the model can then reproduce — awareness helps catch this.',
        ),
        _MockQuestion(
          text: 'Why does responsible AI use matter for an organization?',
          options: {
            'A': 'It has no real-world impact',
            'B': 'It protects against financial, legal, and reputational harm',
            'C': 'It only matters for the IT department',
            'D': 'It slows down all AI adoption unnecessarily',
          },
          correct: 'B',
          wrongExplanation: 'Irresponsible AI use — like data leaks or unverified compliance claims — can create real financial, legal, and reputational consequences.',
        ),
      ],
    ),
  };

  @override
  Future<ModuleQuizContent> getModuleContent({
    required String courseSlug,
    required int moduleIndex,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final data = _modules[moduleIndex] ?? _modules[1]!;

    return ModuleQuizContent(
      success: true,
      courseSlug: courseSlug,
      courseName: 'General AI Knowledge for Everyday Life',
      moduleIndex: moduleIndex,
      title: data.title,
      studyNotes: data.studyNotes,
      totalQuestions: data.questions.length,
      questions: List.generate(data.questions.length, (i) {
        final q = data.questions[i];
        return ModuleQuizQuestion(
          id: moduleIndex * 100 + i + 1,
          questionIndex: i + 1,
          question: q.text,
          options: q.options,
        );
      }),
      submitUrl: '/courses/$courseSlug/modules/$moduleIndex/submit-quiz',
    );
  }

  @override
  Future<ModuleQuizSubmitResult> submitAnswers({
    required String courseSlug,
    required int moduleIndex,
    required Map<int, String> answers,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final data = _modules[moduleIndex] ?? _modules[1]!;

    final results = <ModuleQuizResultItem>[];
    var correctCount = 0;

    answers.forEach((questionId, selected) {
      final qIndex = (questionId % 100) - 1;
      if (qIndex < 0 || qIndex >= data.questions.length) return;

      final q = data.questions[qIndex];
      final isCorrect = selected == q.correct;
      if (isCorrect) correctCount++;

      results.add(ModuleQuizResultItem(
        questionId: questionId,
        selectedOption: selected,
        isCorrect: isCorrect,
        explanation: isCorrect ? null : q.wrongExplanation,
      ));
    });

    final total = data.questions.length;
    final score = total == 0 ? 0.0 : (correctCount / total) * 100;
    final passed = score >= 70;
    final isLastModule = moduleIndex >= 5;

    return ModuleQuizSubmitResult(
      success: true,
      moduleIndex: moduleIndex,
      score: score,
      correctCount: correctCount,
      totalQuestions: total,
      passed: passed,
      message: passed
          ? 'Congratulations! You completed ${data.title} with ${score.round()}% score.'
          : 'You scored ${score.round()}%. You need 70% to pass — give it another try.',
      nextModule: (passed && !isLastModule)
          ? NextModuleInfo(
              moduleIndex: moduleIndex + 1,
              unlocked: true,
              url: '/courses/$courseSlug/modules/${moduleIndex + 1}',
            )
          : null,
      results: results,
    );
  }
}

class _MockModuleData {
  final String title;
  final String studyNotes;
  final List<_MockQuestion> questions;

  _MockModuleData({
    required this.title,
    required this.studyNotes,
    required this.questions,
  });
}

class _MockQuestion {
  final String text;
  final Map<String, String> options;
  final String correct;
  final String wrongExplanation;

  _MockQuestion({
    required this.text,
    required this.options,
    required this.correct,
    required this.wrongExplanation,
  });
}