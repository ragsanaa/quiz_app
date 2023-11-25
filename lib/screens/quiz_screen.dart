import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/models/questions.dart';
import 'package:quiz_app/providers/provider.dart';
import 'package:quiz_app/services/question_service.dart';
import 'package:quiz_app/utils/constants.dart';
import 'package:quiz_app/widgets/question.dart';

class QuizScreen extends ConsumerWidget {
  final String amount;
  final String category;
  final String difficulty;
  final String type;
  const QuizScreen(
      {super.key,
      required this.amount,
      required this.category,
      required this.difficulty,
      required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var nextQuestion = ref.watch(nextQuestionProvider);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [white, lightPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  const Center(
                    child: Text(
                      'Your Quiz',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        GoRouter.of(context).go('/home');
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              mySpacer,
              FutureBuilder(
                future: QuestionService().getQuestions(
                  amount: amount,
                  categoryId: category,
                  difficulty: difficulty,
                  type: type,
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('Something went wrong!');
                  }
                  List<Result> questions = snapshot.data;

                  if (nextQuestion < questions.length) {
                    return Expanded(
                      child: ListView(
                        children: <Widget>[
                          Question(questions[nextQuestion],
                              index: nextQuestion),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PrevNextButton(
                                (nextQuestion >= 0 &&
                                        nextQuestion < questions.length - 1)
                                    ? FontAwesomeIcons.arrowRight
                                    : FontAwesomeIcons.check,
                                direction: nextQuestion == questions.length - 1
                                    ? 'finish'
                                    : 'next',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return const Text('No more questions');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrevNextButton extends ConsumerWidget {
  final IconData icon;
  final String direction;
  const PrevNextButton(this.icon, {super.key, this.direction = 'next'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var nextQuestion = ref.watch(nextQuestionProvider);
    return Padding(
      padding: paddingAll,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              direction == 'finish' ? Colors.green : purpleBlue),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          padding: MaterialStateProperty.all(paddingAll),
          elevation: MaterialStateProperty.all(5),
        ),
        onPressed: () {
          if (direction == 'next') {
            ref
                .read(nextQuestionProvider.notifier)
                .update((state) => state + 1);
            print(nextQuestion);
          } else {
            if (nextQuestion > 0) {
              ref
                  .read(nextQuestionProvider.notifier)
                  .update((state) => state - 1);
            }
          }
        },
        child: FaIcon(
          icon,
          color: white,
          size: iconSize,
        ),
      ),
    );
  }
}
