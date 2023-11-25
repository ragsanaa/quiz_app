import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/utils/constants.dart';
import 'package:quiz_app/widgets/my_custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: paddingAll,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              child: Align(

                alignment: Alignment.topRight,
                child: CircleAvatar(
                  backgroundColor: grey,
                  radius: 25,
                  child: FaIcon(
                    FontAwesomeIcons.solidUser,
                    color: purple,
                  ),
                ),
              ),
              onTap: (){
                GoRouter.of(context).go('/profile');
              },
            ),
            Container(
              padding: paddingAll,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    color: white,
                    width: logoSize,
                  ),
                  mySpacer,
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MyCustomButton('Start Game', route: '/category'),
                        MyCustomButton('Leaderboard', route: '/leaderboard'),
                        MyCustomButton('Settings', route: '/settings'),
                        MyCustomButton('About Us', route: '/about'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
