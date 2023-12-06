import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/models/questions.dart';

class QuestionNotifier extends StateNotifier<List<Result>> {
  QuestionNotifier() : super([]);

  final questions = FirebaseFirestore.instance
      .collection('questions')
      .withConverter(fromFirestore: (snapshot, _) {
    return Result.fromJson(snapshot.data()!, id: snapshot.id);
  }, toFirestore: (model, _) {
    return model.toJson();
  });

  Future<Result> addQuestion(Result question) async {
    final newDocRef = await questions.add(question);
    final newDocId = newDocRef.id;

    return Result.fromJson(question.toJson(), id: newDocId);
  }

  void updateQuestion(String id, Result question) {
    questions.doc(id).update(
        {'isCorrect': question.isCorrect, 'selectedAns': question.selectedAns});
  }
}
