import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/models/question_notifier.dart';
import 'package:quiz_app/models/questions.dart';
import 'package:quiz_app/services/firebase_auth_service.dart';
import 'package:quiz_app/services/question_service.dart';

final sliderValue = StateProvider<int>((ref) => 10);
final radioValue = StateProvider<String>((ref) => 'multiple');
final isRegistredProvider = StateProvider<bool>((ref) => true);
final isForgotPassProvider = StateProvider<bool>((ref) => false);
final readOnlyProvider = StateProvider<bool>((ref) => true);
final categoryIdProvider = StateProvider<String>((ref) => '0');
final difficultyProvider = StateProvider<String>((ref) => '');
final isPressed = StateProvider<bool>((ref) => false);

final nextQuestionProvider = StateProvider<int>((ref) => 0);

final firebaseAuthProvider = Provider.autoDispose<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseAuthService = Provider.autoDispose<FirebaseAuthService>((ref) {
  return FirebaseAuthService(ref.watch(firebaseAuthProvider));
});

final authStateProvider = StreamProvider.autoDispose<User?>((ref) {
  return ref.watch(firebaseAuthService).authStateChanges;
});

final questionsProvider = StreamProvider.autoDispose<List<Result>>(
  (ref) {
    final stream =
        FirebaseFirestore.instance.collection('questions').snapshots();

    return stream.map((event) {
      return event.docs.asMap().entries.map((entry) {
        final int i = entry.key;
        final e = entry.value;
        return Result.fromJson(e.data()["question${i + 1}"], id: e.id);
      }).toList();
    });
  },
);

final questionServiceProvider =
    StateNotifierProvider<QuestionNotifier, List<Result>>(
  (ref) => QuestionNotifier(),
);

final getQuestionProvider = FutureProvider.autoDispose<List<Result>>(
  (ref) async {
    final questions = QuestionService().getQuestions(
      amount: ref.watch(sliderValue).toString(),
      categoryId: ref.watch(categoryIdProvider),
      difficulty: ref.watch(difficultyProvider),
      type: ref.watch(radioValue),
    );
    return questions;
  },
);
