class OptionModel {
  final int id;
  final String text;

  OptionModel({
    required this.id,
    required this.text,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }
}

class QuestionModel {
  final int id;
  final String text;
  final List<OptionModel> options;

  QuestionModel({
    required this.id,
    required this.text,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as int,
      text: json['text'] as String,
      options: (json['options'] as List)
          .map(
            (option) => OptionModel.fromJson(
              option as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}