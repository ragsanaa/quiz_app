import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app/screens/login_screen.dart';
import 'package:quiz_app/utils/constants.dart';

class EntryScreen extends StatelessWidget {
  EntryScreen({super.key});
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          padding: paddingAll * 2,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg1.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/logo.png',
                color: white,
                width: logoSize,
              ),
              Column(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.only(
                            topEnd: Radius.circular(25),
                            topStart: Radius.circular(25),
                          ),
                        ),
                        builder: (context) => LoginScreen(),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(purpleBlue),
                      padding: MaterialStateProperty.all(paddingAll),
                    ),
                    icon: FaIcon(
                      FontAwesomeIcons.envelope,
                      color: white,
                      size: iconSize,
                    ),
                    label: Center(
                      child: Text(
                        'Sign in with Email',
                        style: TextStyle(
                            color: white,
                            fontWeight: bold,
                            fontSize: fontSize * 1.2),
                      ),
                    ),
                  ),
                  mySpacer,
                  TextButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(white),
                      padding: MaterialStateProperty.all(paddingAll),
                    ),
                    icon: FaIcon(
                      FontAwesomeIcons.google,
                      color: purple,
                      size: iconSize,
                    ),
                    label: Center(
                      child: Text('Sign in with Gmail',
                          style: TextStyle(
                              color: purple,
                              fontWeight: bold,
                              fontSize: fontSize * 1.2)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
