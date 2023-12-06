import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/models/questions.dart';
import 'package:quiz_app/providers/provider.dart';
import 'package:quiz_app/utils/constants.dart';

class Question extends ConsumerWidget {
  final Future<Result> question;
  final int index;
  final ValueNotifier<bool> isClicked = ValueNotifier<bool>(false);
  Question(this.question, {Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: paddingAll,
      child: FutureBuilder<Result>(
        future: question,
        builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          Result questionData = snapshot.data!;
          List<Answer> answers = [
            Answer(answer: questionData.correctAnswer!, isCorrect: true),
            ...questionData.incorrectAnswers!
                .map((incorrectAnswer) => Answer(answer: incorrectAnswer)),
          ];
          answers.shuffle();

          return Column(
            children: [
              Text(
                'Q ${index + 1}. ${(questionData.question!)}',
                style: TextStyle(fontSize: fontSize * 2),
              ),
              mySpacer,
              Expanded(
                child: ListView(
                  children: [
                    ...answers.asMap().entries.map((entry) {
                      final answer = entry.value;
                      return Padding(
                        padding: paddingAll,
                        child: ElevatedButton(
                          onPressed: () {
                            final isCorrect = answer.isCorrect;
                            ref
                                .read(isPressed.notifier)
                                .update((state) => !state);
                            ref
                                .read(questionServiceProvider.notifier)
                                .updateQuestion(
                                  questionData.id!,
                                  questionData.copyWith(
                                    selectedAns: answer.answer,
                                    isCorrect: isCorrect,
                                  ),
                                );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              ref.watch(isPressed)
                                  ? answer.isCorrect
                                      ? Colors.green
                                      : Colors.red
                                  : Colors.white,
                            ),
                            padding: MaterialStateProperty.all(paddingAll),
                            elevation: MaterialStateProperty.all(10),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(
                                    color: purple,
                                    width: 2,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              answer.answer,
                              style: TextStyle(
                                  color: purple,
                                  fontWeight: bold,
                                  fontSize: fontSize * 1.2),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
