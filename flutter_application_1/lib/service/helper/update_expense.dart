import "dart:convert";

import "package:flutter_application_1/data/appvalues.dart";
import "package:http/http.dart" as http;


Future<bool> updateExpense(Map<String,dynamic> expense) async {
  try {
    String uuid = expense["uuid"];
    expense.remove("uuid");
    var request = await http.put(
        Uri.parse("${AppValues.ip}updateExpense/$uuid"),
      body: jsonEncode(expense),
      headers: {
        "Content-Type": "application/json",
        "Authorization" : "Bearer ${AppValues.jwtToken}"
      }
    );
    if (request.statusCode == 200) {
      return true;
    }
    return false;
  } catch (e) {
    print("Error on update expense : $e");
    return false;
  }
}

Future<bool> createExpense(Map<String,dynamic> expense) async {
  try {
    var request = await http.post(
        Uri.parse("${AppValues.ip}addExpense"),
      body: jsonEncode({"data":expense}),
      headers: {
        "Content-Type": "application/json",
        "Authorization" : "Bearer ${AppValues.jwtToken}"
      }
    );
    print("Completed request ${request.statusCode}"); 
    if (request.statusCode == 200) {
      return true;
    }
    return false;
  } catch (e) {
    print("Error on create expense : $e");
    return false;
  }
}

Future<bool> addIncome(Map<String,dynamic> income) async {
  try {
    var request = await http.post(
        Uri.parse("${AppValues.ip}/addExpense"),
      body: jsonEncode(income),
      headers: {
        "Content-Type": "application/json",
        "Authorization" : "Bearer ${AppValues.jwtToken}"
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