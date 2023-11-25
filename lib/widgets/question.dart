import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz_app/models/questions.dart';
import 'package:quiz_app/utils/constants.dart';

class Question extends StatelessWidget {
  final unescape = HtmlUnescape();
  final int index;
  final Result question;
  Question(this.question, {super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    List<Answer> answers = [];
    answers.add(Answer(answer: question.correctAnswer, isCorrect: true));
    answers.addAll(question.incorrectAnswers
        .map((incorrectAnswer) => Answer(answer: incorrectAnswer)));
    answers.shuffle();
    answers.shuffle();
    return Container(
      padding: paddingAll,
      child: Column(
        children: [
          Text(
            'Q ${index + 1}. ${unescape.convert(question.question)}',
            style: TextStyle(fontSize: fontSize * 2),
          ),
          mySpacer,
          ...answers.map((answer) {
            return Padding(
              padding: paddingAll,
              child: ElevatedButton(
                onPressed: () {
                  answer = answer.copyWith(isSelected: !answer.isSelected);
                },
                style: ButtonStyle(
                  backgroundColor: answer.isSelected
                      ? MaterialStateProperty.all(lightPurple)
                      : MaterialStateProperty.all(white),
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
                  child: Text(unescape.convert(answer.answer),
                      style: TextStyle(
                          color: purple,
                          fontWeight: bold,
                          fontSize: fontSize * 1.2)),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
