
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/view/analytics/analytics_view.dart';
import 'package:flutter_application_1/components/view/expenses/expenses_view.dart';
import 'package:flutter_application_1/components/view/main_screeen.dart';
import 'package:flutter_application_1/components/view/settings/settings.dart';
import 'package:flutter_application_1/components/view/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Widget myApp = MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/" : (BuildContext context) => SplashScreen(),
      "/main" : (BuildContext context) => MainScreen(),
      "/analytics" : (BuildContext context) => AnalyticsView(),
      "/expenses" : (BuildContext context) => ExpensesView(),
      "/settings" : (BuildContext context) => Settings()
    },
  );
  runApp(myApp);
}