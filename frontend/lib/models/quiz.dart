class Question {
  final String id;
  final String text;
  final List<String> options;
  final String answer;
  final int level;
  final String category;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.answer,
    required this.level,
    required this.category,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
      level: json['level'],
      category: json['category'],
    );
  }
}

class Quiz {
  final String id;
  final String title;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}