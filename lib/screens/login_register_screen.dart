import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/providers/provider.dart';
import 'package:quiz_app/services/firebase_auth_service.dart';
import 'package:quiz_app/utils/constants.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});
  final formKey = GlobalKey<FormState>();
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRegistred = ref.watch(isRegistredProvider);
    final isForgotPass = ref.watch(isForgotPassProvider);

    final FirebaseAuthService authService = ref.read(firebaseAuthService);
    final FirebaseAuth auth = ref.read(firebaseAuthProvider);

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(40, 5, 40, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              isRegistred && !isForgotPass
                  ? 'Account Login'
                  : isForgotPass
                      ? 'Forgot Password'
                      : 'Create Account',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                if (!isRegistred && !isForgotPass) ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: usernameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      contentPadding: paddingAll,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                  ),
                ],
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    bool isValid = EmailValidator.validate(value!);
                    if (value.isEmpty) {
                      return 'Please enter email';
                    } else if (!isValid) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                ),
                if (!isForgotPass) ...[
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      isRegistred && !isForgotPass
                          ? await loginUser(authService, context)
                          : isForgotPass
                              ? await auth.sendPasswordResetEmail(
                                  email: emailCtrl.text)
                              : await registerUser(auth, context);
                      if (isRegistred && !isForgotPass) {
                        GoRouter.of(context).go('/home');
                        ref.read(isRegistredProvider.notifier).update((state) {
                          return !state;
                        });
                      } else if (isForgotPass) {
                        GoRouter.of(context).go('/entry');

                        ref.read(isForgotPassProvider.notifier).update((state) {
                          return !state;
                        });
                      }
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
                  child: Center(
                    child: Text(
                      isRegistred && !isForgotPass
                          ? 'Sign in'
                          : isForgotPass
                              ? 'Reset'
                              : 'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize * 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isRegistred) ...[
            const SizedBox(height: 10),
            if (!isForgotPass)
              TextButton(
                onPressed: () {
                  ref
                      .read(isForgotPassProvider.notifier)
                      .update((state) => !state);
                  GoRouter.of(context).go('/entry');
                },
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
                    ref
                        .read(isRegistredProvider.notifier)
                        .update((state) => !state);
                    if (isForgotPass) {
                      ref
                          .read(isForgotPassProvider.notifier)
                          .update((state) => !state);
                    }
                    GoRouter.of(context).go('/entry');
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
          ]
        ],
      ),
    );
  }

  Future<void> loginUser(FirebaseAuthService auth, BuildContext context) async {
    User? user = await auth.signInWithEmailAndPassword(
        emailCtrl.text, passwordCtrl.text);
    emailCtrl.clear();
    passwordCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Login Successful',
        ),
      ),
    );
  }

  Future<void> registerUser(FirebaseAuth auth, BuildContext context) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: emailCtrl.text,
      password: passwordCtrl.text,
    );
    userCredential.user!.updateDisplayName(
      usernameCtrl.text,
    );
    usernameCtrl.clear();
    emailCtrl.clear();
    passwordCtrl.clear();
    GoRouter.of(context).go('/home');
  }
}
