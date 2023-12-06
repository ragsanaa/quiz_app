import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/providers/provider.dart';
import 'package:quiz_app/services/cloud_service.dart';
import 'package:quiz_app/utils/constants.dart';

class ProfileScreen extends ConsumerWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final userNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  CloudService cloudService = CloudService();

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      GoRouter.of(context).go('/entry');
    } catch (e) {
      print('Sign out error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign out failed. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = ref.watch(firebaseAuthProvider).currentUser;
    final isReadOnly = ref.watch(readOnlyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          onPressed: () => GoRouter.of(context).go('/home'),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _signOut(context);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: FutureBuilder(
                future: cloudService.getFile(user?.photoURL ?? ''),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(snapshot.data.toString() ??
                        'https://yt3.googleusercontent.com/-CFTJHU7fEWb7BYEb6Jh9gm1EpetvVGQqtof0Rbh-VQRIznYYKJxCaqv_9HeBcmJmIsp2vOO9JU=s900-c-k-c0x00ffffff-no-rj'),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png', 'jpeg'],
                          );
                          cloudService.uploadFile(
                              result?.files.single.name ?? '',
                              result?.files.single.path ?? '',
                              'avatars');
                          if (result != null) {
                            ref
                                .read(firebaseAuthProvider)
                                .currentUser
                                ?.updatePhotoURL(result.files.single.name);
                          }
                        },
                        icon: CircleAvatar(
                            radius: 25,
                            child: Icon(
                              Icons.edit,
                              color: purple,
                              size: 30,
                            )),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Username',
              style: TextStyle(
                fontSize: fontSize * 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              readOnly: isReadOnly,
              controller: userNameCtrl
                ..text = user?.displayName?.toUpperCase() ?? '',
              style: TextStyle(
                fontSize: fontSize * 1.5,
              ),
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Email',
              style: TextStyle(
                fontSize: fontSize * 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              readOnly: isReadOnly,
              controller: emailCtrl..text = user?.email ?? '',
              style: TextStyle(
                fontSize: fontSize * 1.5,
              ),
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                ref.read(readOnlyProvider.notifier).update((state) => !state);
                if (!isReadOnly) {
                  ref
                      .read(firebaseAuthProvider)
                      .currentUser
                      ?.updateDisplayName(userNameCtrl.text.toUpperCase());
                  ref
                      .read(firebaseAuthProvider)
                      .currentUser
                      ?.updateEmail(emailCtrl.text.toLowerCase());
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(purpleBlue),
                padding: MaterialStateProperty.all(paddingAll),
              ),
              child: Text(isReadOnly ? 'Edit Profile' : 'Save Changes',
                  style: TextStyle(fontSize: fontSize * 1.5, color: white)),
            )
          ],
        ),
      ),
    );
  }
}
