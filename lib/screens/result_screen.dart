import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/providers/provider.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var amount = ref.watch(sliderValue).toString();
    var category = ref.watch(categoryIdProvider);
    var difficulty = ref.watch(difficultyProvider);
    var questions = ref.watch(questionsProvider);

    var correctCount = 0;
    var wrongCount = 0;

    questions.when(
      data: (data) {
        for (var i = 0; i < data.length; i++) {
          if (data[i].selectedAns == data[i].correctAnswer) {
            correctCount += 1;
          } else {
            if (data[i].selectedAns != null) {
              wrongCount += 1;
            }
          }
        }
      },
      loading: () {
        return const CircularProgressIndicator();
      },
      error: (e, s) {},
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Correct Answers: $correctCount',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Wrong Answers: $wrongCount',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/category');
              },
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
