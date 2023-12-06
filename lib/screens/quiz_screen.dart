import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/models/questions.dart';
import 'package:quiz_app/providers/provider.dart';
import 'package:quiz_app/utils/constants.dart';
import 'package:quiz_app/widgets/question.dart';

class QuizScreen extends ConsumerWidget {
  QuizScreen({super.key});
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var amount = ref.watch(sliderValue).toString();
    var category = ref.watch(categoryIdProvider);
    var difficulty = ref.watch(difficultyProvider);
    var type = ref.watch(radioValue);
    var nextQuestion = ref.watch(nextQuestionProvider);

    var questions = ref.watch(getQuestionProvider);

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
              questions.when(
                data: (data) {
                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var newQuestion = ref
                                  .read(questionServiceProvider.notifier)
                                  .addQuestion(data[index]);

                              return Question(
                                newQuestion,
                                index: index,
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (nextQuestion < int.parse(amount) - 1)
                              PrevNextButton(
                                FontAwesomeIcons.arrowRight,
                                pageController: _pageController,
                                questions: data,
                              ),
                            if (nextQuestion == int.parse(amount) - 1)
                              PrevNextButton(
                                FontAwesomeIcons.check,
                                direction: 'finish',
                                pageController: _pageController,
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text(error.toString()),
                ),
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
  final PageController pageController;
  final List<Result> questions;

  const PrevNextButton(this.icon,
      {Key? key,
      required this.pageController,
      this.direction = 'next',
      this.questions = const []})
      : super(key: key);

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
            ref.read(isPressed.notifier).update((state) {
              return false;
            });
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          }
          // else {
          //   if (nextQuestion > 0) {
          //     ref
          //         .read(nextQuestionProvider.notifier)
          //         .update((state) => state - 1);
          //     pageController.previousPage(
          //       duration: const Duration(milliseconds: 500),
          //       curve: Curves.ease,
          //     );
          //   }
          // }
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
