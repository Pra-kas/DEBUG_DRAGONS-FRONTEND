
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/view/analytics/analytics_view.dart';

void main() {
  Widget myApp = MaterialApp(
    initialRoute: "/",
    routes: {
      "/" : (BuildContext context) => AnalyticsView()
    },
  );
  runApp(myApp);
}