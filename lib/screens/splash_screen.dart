import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/providers/provider.dart';
import 'package:quiz_app/utils/constants.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = ref.watch(authStateProvider).value;
    Future<void>.delayed(const Duration(seconds: 1), () {

      if (user != null) {
        GoRouter.of(context).go('/home');
      } else {
        GoRouter.of(context).go('/entry');
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Image.asset(
            "assets/images/logo.png",
            color: white,
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
          ),
        ),
      ),
    );
  }
}
