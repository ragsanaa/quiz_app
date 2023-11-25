import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/utils/constants.dart';

class MyCustomBackIcon extends StatelessWidget {
  const MyCustomBackIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        onPressed: () {
          if(GoRouter.of(context).canPop()) {
            GoRouter.of(context).pop();
          } else {
            GoRouter.of(context).go('/home');
          }
        },
        icon: FaIcon(
          FontAwesomeIcons.chevronLeft,
          color: white,
          size: iconSize * 0.6,
        ),
      ),
    );
  }
}
