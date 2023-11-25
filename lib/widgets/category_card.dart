import 'package:flutter/material.dart';
import 'package:quiz_app/utils/constants.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final int id;
  final int quizCount;
  final void Function() onTap;
  const CategoryCard({
    super.key,
    required this.name,
    required this.id,
    this.quizCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: paddingAll,
        padding: paddingAll * 2.5,
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: grey,
              offset: const Offset(-2, 3),
              blurRadius: 3.0,
              spreadRadius: 3,
            )
          ],
          image: const DecorationImage(
              image: AssetImage('assets/images/bg_card.jpeg'),
              fit: BoxFit.cover,
              opacity: 0.8),
        ),
        child: Center(
          child: ListTile(
            title: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize * 2,
                fontWeight: bold,
              ),
            ),
            subtitle: (quizCount > 0)
                ? Text(
                    '$quizCount Quizzes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize * 1.5,
                      fontWeight: bold,
                    ),
                  )
                : null,
          ),
        ),
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
