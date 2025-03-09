import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/components/models/expense_model.dart';
import 'package:flutter_application_1/data/appvalues.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

Future<String> uploadBill(XFile image) async {
  try {
    List<int> imageBytes = await image.readAsBytes();
    String base64String = base64Encode(imageBytes);
    print("The string is $base64String");
    var response = await http.post(
      Uri.parse("${AppValues.ip}addExpenseByBill"),
      headers: {
        "Authorization" : "Bearer ${AppValues.jwtToken}"
      },
      body: {"image64": base64String},
    );
    if (response.statusCode == 200) {
      return "Upload successful: ${response.body}";
    } else {
      return "Upload failed: ${response.statusCode} - ${response.body}";
    }
  } catch (e) {
    return "Error: $e";
  }
}

Future<String> uploadPdf(FilePickerResult pdf) async {
  try {
    if (pdf.files.isEmpty) {
      return "No file selected";
    }

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${AppValues.ip}addBankStatement"),
    );
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Authorization" : "Bearer ${AppValues.jwtToken}"
    });
    File file = File(pdf.files.single.path!);
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      filename: pdf.files.single.name,
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      return "Upload successful";
    } else {
      return "Upload failed: ${response.statusCode}";
    }
  } catch (e) {
    return "Error: $e";
  }
}


Future<dynamic> getExpenses() async {
    try{
      List<Map<String,dynamic>> expenses = [];
      // print("JWT token : ${AppValues.jwtToken}");
      var response = await http.get(
          Uri.parse("${AppValues.ip}getExpense"),
        headers: {
          "Content-Type": "multipart/form-data",
          "Authorization" : "Bearer ${AppValues.jwtToken}"
        }
      );
      List<Map<String,dynamic>> recurringExpenses = [];      
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        for(var expense in data["data"]){
            recurringExpenses.add(expense);
        }
        for(var expense in data["message"]){
          expenses.add(expense);
        }
        print("Success: $expenses");
        return {
          "expenses": expenses,
          "recurringExpenses": recurringExpenses
        };
      }
    }
    catch(e){
      print("Error: $e");
    }
    return [];
}

Future<String> getChatBotResponse(String message) async {
  try {
    var response = await http.post(
      Uri.parse("${AppValues.ip}botQuery"),
      headers: {
        "Authorization" : "Bearer ${AppValues.jwtToken}"
      },
      body: {"botQuery": message},
    );
    var decodedResponse = jsonDecode(response.body);
    if (decodedResponse["status"] == 200) {
      return jsonDecode(response.body)["answer"];
    } 
    else if(decodedResponse["status"] == 404){
      return decodedResponse["message"];
    }
    else {
      return "Error: ${response.statusCode} - ${response.body}";
    }
  } catch (e) {
    return "Error: $e";
  }
}