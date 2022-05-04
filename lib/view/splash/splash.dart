import 'dart:async';

import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/utils/routes.dart';
import 'package:co_sport_map/view/auth/gauth_page.dart';
import 'package:co_sport_map/view/splash/on_boarding.dart';
import 'package:co_sport_map/widget/build_botton_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final String? _userId = Constants.prefs!.getString('userId');
  // final String? _firsttime = Constants.prefs!.getString('firsttime');
  startTimeout() {
    return Timer(const Duration(milliseconds: 2200), handleTimeout);
  }

  void handleTimeout() {
    changeScreen();
  }

  changeScreen() async {
    _userId == null
        ? CRouter.pushPageWithFadeAnimation(context, const GauthPage())
        : Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AnimatedBottomBar()));
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
      startTimeout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Opacity(
                opacity: 0.85,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                  child: Image(
                    image: AssetImage('assets/co_sport.png'),
                    width: 150,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 170,
            ),
            Text(
              "Co Sport",
              style: TextStyle(
                color: Theme.of(context).backgroundColor.withOpacity(0.25),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
