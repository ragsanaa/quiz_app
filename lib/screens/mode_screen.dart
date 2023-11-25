import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/providers/provider.dart';
import 'package:quiz_app/services/question_service.dart';
import 'package:quiz_app/utils/constants.dart';
import 'package:quiz_app/widgets/abstract_card.dart';
import 'package:quiz_app/widgets/category_card.dart';
import 'package:quiz_app/widgets/my_custom_back_icon.dart';

class ModeScreen extends ConsumerWidget {
  final String id;
  const ModeScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _onTap(int count) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: ListTile(
            title: Text('Select a number of questions and type',
                style: TextStyle(fontSize: fontSize * 1.5)),
            subtitle: const Text('The maximum is 50'),
          ),
          content: SingleChildScrollView(
            child: Consumer(
              builder: (context, ref, child) {
                final currentSliderValue = ref.watch(sliderValue);
                return Column(
                  children: [
                    Slider(
                      value: currentSliderValue.toDouble(),
                      max: 50,
                      divisions: count,
                      onChanged: (value) {
                        ref.read(sliderValue.notifier).state = value.toInt();
                      },
                      activeColor: purple,
                      inactiveColor: lightPurple,
                      label: currentSliderValue.toString(),
                    ),
                    RadioMenuButton(
                      value: 'multiple',
                      groupValue: ref.watch(radioValue),
                      onChanged: (value) {
                        ref.read(radioValue.notifier).state = value.toString();
                      },
                      child: const Text('Multiple Choice'),
                    ),
                    RadioMenuButton(
                        value: 'boolean',
                        groupValue: ref.watch(radioValue),
                        onChanged: (value) {
                          ref.read(radioValue.notifier).state =
                              value.toString();
                        },
                        child: const Text('True / False')),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                GoRouter.of(context).goNamed('quiz', queryParameters: {
                  'amount': ref.watch(sliderValue).toString(),
                  'category': id,
                  'difficulty': 'easy',
                  'type': 'multiple',
                });
              },
              child: const Text('Start'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: lightPurple,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const MyCustomBackIcon(),
              const AbstractCard(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    color: white,
                  ),
                  child: Column(
                    children: [
                      mySpacer,
                      Text(
                        'Select a Difficulty',
                        style: TextStyle(
                          color: purple,
                          fontSize: fontSize * 2,
                          fontWeight: bold,
                        ),
                      ),
                      FutureBuilder(
                        future: QuestionService()
                            .getCategoryQuestionCount(categoryId: id),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Something went wrong!'));
                          }
                          return Expanded(
                            child: ListView(
                              children: [
                                CategoryCard(
                                  name: 'Easy',
                                  id: int.parse(id),
                                  quizCount:
                                      snapshot.data.totalEasyQuestionCount,
                                  onTap: () {
                                    _onTap(
                                        snapshot.data.totalEasyQuestionCount);
                                  },
                                ),
                                CategoryCard(
                                  name: 'Medium',
                                  id: int.parse(id),
                                  quizCount:
                                      snapshot.data.totalMediumQuestionCount,
                                  onTap: () {
                                    _onTap(
                                        snapshot.data.totalMediumQuestionCount);
                                  },
                                ),
                                CategoryCard(
                                  name: 'Hard',
                                  id: int.parse(id),
                                  quizCount:
                                      snapshot.data.totalHardQuestionCount,
                                  onTap: () {
                                    _onTap(
                                        snapshot.data.totalHardQuestionCount);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
