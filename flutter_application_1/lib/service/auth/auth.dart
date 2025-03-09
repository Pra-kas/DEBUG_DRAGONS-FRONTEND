
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../data/appvalues.dart';
Future<bool> authService() async {
  try {
    var request = await http.get(
        Uri.parse("${AppValues.ip}login"),
        headers: {
          "Content-Type": "application/json",
          "Authorization" : AppValues.jwtToken
        }
    );
    if (request.statusCode == 200) {
      return true;
    }
    return false;
  } catch (e) {
    print("Error on add income : $e");
    return false;
  }
}

Future<bool> sendFCM() async {
  try {
    Map<String,dynamic> body = {
      "fcm" : AppValues.fcm
    };
    var request = await http.post(
        Uri.parse("${AppValues.ip}fcm"),
        headers: {
          "Content-Type": "application/json",
          "Authorization" : AppValues.jwtToken
        },
      body: jsonEncode(body)
    );
    if (request.statusCode == 200) {
      return true;
    }
    return false;
  } catch (e) {
    print("Error on add income : $e");
    return false;
  }
}