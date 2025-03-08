import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    navigateToMainScreen();
    super.initState();
  }

  Future<void> navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushNamed(context, "/main");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: true ? CircleAvatar(backgroundColor: white,) : Image(image: AssetImage("assets/images/applogo.png"))
      ),
    );
  }
}
