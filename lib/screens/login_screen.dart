import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/providers/provider.dart';
import 'package:quiz_app/services/firebase_auth_service.dart';
import 'package:quiz_app/utils/constants.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuthService auth = ref.read(firebaseAuthService);
    return Scaffold(
      body: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(40, 5, 40, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FractionallySizedBox(
              widthFactor: 0.25,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 12.0,
                ),
                child: Container(
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(2.5)),
                  ),
                ),
              ),
            ),
            const Center(
              child: Text(
                'Account Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                contentPadding: paddingAll,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordCtrl,
              obscureText: true,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                contentPadding: paddingAll,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      showCloseIcon: true,
                      content: Text(
                        'Please fill all fields',
                      ),
                    ),
                  );
                } else {
                  User? user = await auth.signInWithEmailAndPassword(
                      emailCtrl.text, passwordCtrl.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Login Successful',
                      ),
                    ),
                  );
                  Navigator.pop(context);
                  GoRouter.of(context).go('/home');
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(purple),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: MaterialStateProperty.all(paddingAll),
              ),
              child: Text(
                'Sign in',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize * 1.2,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: purple,
                  fontWeight: bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).go('/register');
                  },
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      color: purpleBlue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
