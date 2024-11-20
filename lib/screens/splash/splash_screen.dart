import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_market/root_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static String routeName = "splash";
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context,RootScreen.routName);
    });
    return Scaffold(
      body: SvgPicture.asset(
        //? --> path image 
        "assets/images/splash.svg",
        height: mediaQuery.height,
        width: mediaQuery.width,
        fit: BoxFit.fill,
      ),
    );
  }
}
