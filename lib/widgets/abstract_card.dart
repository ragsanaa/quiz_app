import 'package:flutter/material.dart';
import 'package:quiz_app/utils/constants.dart';

class AbstractCard extends StatelessWidget {
  const AbstractCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: paddingAll,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
          colors: [
            gradientStart,
            gradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Discover \nNew \nQuizzes',
            style: TextStyle(
              color: white,
              fontSize: fontSize * 2,
              fontWeight: bold,
            ),
          ),
          Image.asset(
            'assets/images/icon11.png',
            width: 170,
          ),
        ],
      ),
    );
  }
}
