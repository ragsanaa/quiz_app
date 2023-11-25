import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/services/firebase_auth_service.dart';

final sliderValue = StateProvider<int>((ref) => 10);
final radioValue = StateProvider<String>((ref) => 'multiple');

final nextQuestionProvider = StateProvider<int>((ref) => 0);

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseAuthService = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService(ref.watch(firebaseAuthProvider));
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthService).authStateChanges;
});
