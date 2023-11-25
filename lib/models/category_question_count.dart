class CategoryQuestionCount {
  final int categoryId;
  final CategoryQuestionCountClass categoryQuestionCount;

  CategoryQuestionCount({
    required this.categoryId,
    required this.categoryQuestionCount,
  });

  factory CategoryQuestionCount.fromJson(Map<String, dynamic> json) =>
      CategoryQuestionCount(
        categoryId: json["category_id"],
        categoryQuestionCount: CategoryQuestionCountClass.fromJson(
            json["category_question_count"]),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_question_count": categoryQuestionCount.toJson(),
      };
}

class CategoryQuestionCountClass {
  final int totalQuestionCount;
  final int totalEasyQuestionCount;
  final int totalMediumQuestionCount;
  final int totalHardQuestionCount;

  CategoryQuestionCountClass({
    required this.totalQuestionCount,
    required this.totalEasyQuestionCount,
    required this.totalMediumQuestionCount,
    required this.totalHardQuestionCount,
  });

  factory CategoryQuestionCountClass.fromJson(Map<String, dynamic> json) =>
      CategoryQuestionCountClass(
        totalQuestionCount: json["total_question_count"],
        totalEasyQuestionCount: json["total_easy_question_count"],
        totalMediumQuestionCount: json["total_medium_question_count"],
        totalHardQuestionCount: json["total_hard_question_count"],
      );

  Map<String, dynamic> toJson() => {
        "total_question_count": totalQuestionCount,
        "total_easy_question_count": totalEasyQuestionCount,
        "total_medium_question_count": totalMediumQuestionCount,
        "total_hard_question_count": totalHardQuestionCount,
      };
}
