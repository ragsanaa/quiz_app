class Questions {
  final int responseCode;
  final List<Result> results;

  Questions({
    required this.responseCode,
    required this.results,
  });

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        responseCode: json["response_code"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response_code": responseCode,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  final Type type;
  final Difficulty difficulty;
  final Category category;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  Result({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        type: typeValues.map[json["type"]]!,
        difficulty: difficultyValues.map[json["difficulty"]]!,
        category: categoryValues.map[json["category"]]!,
        question: json["question"],
        correctAnswer: json["correct_answer"],
        incorrectAnswers:
            List<String>.from(json["incorrect_answers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "difficulty": difficultyValues.reverse[difficulty],
        "category": categoryValues.reverse[category],
        "question": question,
        "correct_answer": correctAnswer,
        "incorrect_answers": List<dynamic>.from(incorrectAnswers.map((x) => x)),
      };
}

enum Category { GENERAL_KNOWLEDGE }

final categoryValues =
    EnumValues({"General Knowledge": Category.GENERAL_KNOWLEDGE});

enum Difficulty { EASY, HARD, MEDIUM }

final difficultyValues = EnumValues({
  "easy": Difficulty.EASY,
  "hard": Difficulty.HARD,
  "medium": Difficulty.MEDIUM
});

enum Type { BOOLEAN, MULTIPLE }

final typeValues =
    EnumValues({"boolean": Type.BOOLEAN, "multiple": Type.MULTIPLE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class Answer {
  final String answer;
  final bool isCorrect;
  final bool isSelected;

  Answer({
    required this.answer,
    this.isCorrect = false,
    this.isSelected = false,
  });

  Answer copyWith({
    String? answer,
    bool? isCorrect,
    bool? isSelected,
  }) {
    return Answer(
      answer: answer ?? this.answer,
      isCorrect: isCorrect ?? this.isCorrect,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
