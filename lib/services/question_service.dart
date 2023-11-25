import 'package:dio/dio.dart';
import 'package:quiz_app/models/categories.dart';
import 'package:quiz_app/models/category_question_count.dart';
import 'package:quiz_app/models/questions.dart';

class QuestionService {
  Dio dio = Dio();
  Future<List<QCategory>> getCategories() async {
    String url = 'https://opentdb.com/api_category.php';
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      return Categories.fromJson(response.data).categories;
    }
    return [];
  }

  Future<List<Result>> getQuestions(
      {required String amount,
      String categoryId = '0',
      String difficulty = '',
      String type = ''}) async {
    String url =
        'https://opentdb.com/api.php?amount=$amount&category=$categoryId&difficulty=$difficulty&type=$type';
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      return Questions.fromJson(response.data).results;
    }
    return [];
  }

  Future<CategoryQuestionCountClass> getCategoryQuestionCount(
      {required String categoryId}) async {
    String url = 'https://opentdb.com/api_count.php?category=$categoryId';
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      return CategoryQuestionCount.fromJson(response.data)
          .categoryQuestionCount;
    }
    return CategoryQuestionCountClass(
      totalQuestionCount: 0,
      totalEasyQuestionCount: 0,
      totalMediumQuestionCount: 0,
      totalHardQuestionCount: 0,
    );
  }
}
