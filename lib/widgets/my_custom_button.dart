import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/utils/constants.dart';

class MyCustomButton extends ConsumerWidget {
  final String text;
  final String route;
  const MyCustomButton(this.text, {super.key, this.route = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        GoRouter.of(context).go(route);
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(paddingAll),
        elevation: MaterialStateProperty.all(10),
      ),
      child: Center(
        child: Text(text,
            style: TextStyle(
                color: purple, fontWeight: bold, fontSize: fontSize * 1.2)),
      ),
    );
  }
}
