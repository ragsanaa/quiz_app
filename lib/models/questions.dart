import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

final unescape = HtmlUnescape();

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
  String? id;
  Type? type;
  Difficulty? difficulty;
  Category? category;
  String? question;
  String? correctAnswer;
  List<String>? incorrectAnswers;
  String? selectedAns;
  bool? isCorrect;

  Result({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    this.selectedAns,
    this.isCorrect,
  });

  Result.fromJson(Map<String, dynamic> json, {this.id}) {
    type = typeValues.map[json["type"]];
    difficulty = difficultyValues.map[json["difficulty"]];
    category = categoryValues.map[json["category"]];
    question = unescape.convert(json["question"]);
    correctAnswer = unescape.convert(json["correct_answer"]);
    incorrectAnswers = List<String>.from(
        json["incorrect_answers"]?.map((x) => unescape.convert(x)));
    selectedAns = json["selectedAns"];
    isCorrect = json["isCorrect"];
  }

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "difficulty": difficultyValues.reverse[difficulty],
        "category": categoryValues.reverse[category],
        "question": question,
        "correct_answer": correctAnswer,
        "incorrect_answers":
            List<dynamic>.from(incorrectAnswers!.map((x) => x)),
      };

  Result copyWith({
    Type? type,
    Difficulty? difficulty,
    Category? category,
    String? question,
    String? correctAnswer,
    List<String>? incorrectAnswers,
    String? selectedAns,
    bool? isCorrect,
  }) {
    return Result(
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      question: question ?? this.question,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      selectedAns: selectedAns ?? this.selectedAns,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
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
  Color buttonColor;

  Answer({
    required this.answer,
    this.isCorrect = false,
    this.isSelected = false,
    this.buttonColor = Colors.white,
  });

  Answer copyWith({
    String? answer,
    bool? isCorrect,
    bool? isSelected,
    Color? buttonColor,
  }) {
    return Answer(
      answer: answer ?? this.answer,
      isCorrect: isCorrect ?? this.isCorrect,
      isSelected: isSelected ?? this.isSelected,
      buttonColor: buttonColor ?? this.buttonColor,
    );
  }
}
