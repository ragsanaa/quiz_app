import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/models/questions.dart';
import 'package:quiz_app/providers/provider.dart';
import 'package:quiz_app/utils/constants.dart';

class Question extends ConsumerWidget {
  final Future<Result> question;
  final int index;
  List<Answer> answers = [];

  Question(this.question, {Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: paddingAll,
      child: FutureBuilder(
        future: question,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          var questionData = snapshot.data as Result;

          if (answers.isEmpty) {
            answers.add(Answer(
                answer: questionData.correctAnswer!,
                isCorrect: true,
                buttonColor: Colors.green));
            answers.addAll(questionData.incorrectAnswers!.map(
                (incorrectAnswer) => Answer(
                    answer: incorrectAnswer,
                    isCorrect: false,
                    buttonColor: Colors.red)));
            answers.shuffle();
          }

          return _buildQuestionWidget(questionData, answers, ref);
        },
      ),
    );
  }

  Widget _buildQuestionWidget(
      Result questionData, List<Answer> answers, WidgetRef ref) {
    final button1 = ref.watch(isPressed1);
    final button2 = ref.watch(isPressed2);
    final button3 = ref.watch(isPressed3);
    final button4 = ref.watch(isPressed4);
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
              Padding(
                padding: paddingAll,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(isPressed1.notifier).update((state) => !state);
                    if (answers[0].answer == questionData.correctAnswer) {
                      ref.read(questionServiceProvider.notifier).updateQuestion(
                          questionData.id!,
                          questionData.copyWith(
                              selectedAns: answers[0].answer, isCorrect: true));
                    } else {
                      ref.read(questionServiceProvider.notifier).updateQuestion(
                          questionData.id!,
                          questionData.copyWith(
                              selectedAns: answers[0].answer,
                              isCorrect: false));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        button1 ? answers[0].buttonColor : white),
                    padding: MaterialStateProperty.all(paddingAll),
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                            color: purple, width: 2, style: BorderStyle.solid),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(answers[0].answer,
                        style: TextStyle(
                            color: purple,
                            fontWeight: bold,
                            fontSize: fontSize * 1.2)),
                  ),
                ),
              ),
              Padding(
                padding: paddingAll,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(isPressed2.notifier).update((state) => !state);
                    if (answers[1].answer == questionData.correctAnswer) {
                      ref.read(questionServiceProvider.notifier).updateQuestion(
                          questionData.id!,
                          questionData.copyWith(
                              selectedAns: answers[1].answer, isCorrect: true));
                    } else {
                      ref.read(questionServiceProvider.notifier).updateQuestion(
                          questionData.id!,
                          questionData.copyWith(
                              selectedAns: answers[1].answer,
                              isCorrect: false));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        button2 ? answers[1].buttonColor : white),
                    padding: MaterialStateProperty.all(paddingAll),
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                            color: purple, width: 2, style: BorderStyle.solid),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(answers[1].answer,
                        style: TextStyle(
                            color: purple,
                            fontWeight: bold,
                            fontSize: fontSize * 1.2)),
                  ),
                ),
              ),
              if (answers.length > 2)
                Padding(
                  padding: paddingAll,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(isPressed3.notifier).update((state) => !state);
                      if (answers[2].answer == questionData.correctAnswer) {
                        ref
                            .read(questionServiceProvider.notifier)
                            .updateQuestion(
                                questionData.id!,
                                questionData.copyWith(
                                    selectedAns: answers[2].answer,
                                    isCorrect: true));
                      } else {
                        ref
                            .read(questionServiceProvider.notifier)
                            .updateQuestion(
                                questionData.id!,
                                questionData.copyWith(
                                    selectedAns: answers[2].answer,
                                    isCorrect: false));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          button3 ? answers[2].buttonColor : white),
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
                      child: Text(answers[2].answer,
                          style: TextStyle(
                              color: purple,
                              fontWeight: bold,
                              fontSize: fontSize * 1.2)),
                    ),
                  ),
                ),
              if (answers.length > 3)
                Padding(
                  padding: paddingAll,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(isPressed4.notifier).update((state) => !state);
                      if (answers[3].answer == questionData.correctAnswer) {
                        ref.read(isPressed4.notifier).update((state) => !state);

                        ref
                            .read(questionServiceProvider.notifier)
                            .updateQuestion(
                                questionData.id!,
                                questionData.copyWith(
                                    selectedAns: answers[3].answer,
                                    isCorrect: true));
                      } else {
                        ref
                            .read(questionServiceProvider.notifier)
                            .updateQuestion(
                                questionData.id!,
                                questionData.copyWith(
                                    selectedAns: answers[3].answer,
                                    isCorrect: false));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          button4 ? answers[3].buttonColor : white),
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
                      child: Text(answers[3].answer,
                          style: TextStyle(
                              color: purple,
                              fontWeight: bold,
                              fontSize: fontSize * 1.2)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
