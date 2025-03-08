import 'dart:convert';
import 'dart:io';
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
      body: {"image": base64String},
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
