import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/view/Auth/login_view.dart';
import 'package:flutter_application_1/components/view/main_screeen.dart';
import 'package:flutter_application_1/data/appvalues.dart';

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

    try {
      var user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // User is not logged in, navigate to LoginPage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false,
        );
      } else {
        String? jwtToken = await user.getIdToken();
        if (jwtToken == null) {
          throw Exception("Unauthorized");
        }
        AppValues.jwtToken = jwtToken;
        // User is logged in, navigate to MainScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print("Error in splash screen: $e");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 60,
          ),
        ),
      ),
    );
  }
}
