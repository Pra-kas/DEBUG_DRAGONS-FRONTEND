import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../data/appvalues.dart';

class GlobalService {
  static Future<dynamic> globalService(
      {required String endpoint,
      Map<String, dynamic>? requestBody,
      required String method}) async {
    final Uri url =
        Uri.parse("${AppValues.ip}$endpoint"); // ✅ Uses passed endpoint
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    try {
      http.Response response =
          await _makeRequest(url, headers, method, requestBody);

      if (response.statusCode == 401) {
        // 🔄 Refresh token and retry
        response = await _makeRequest(url, headers, method, requestBody);
      }

      // 🛠 Handle all response codes properly
      return _handleResponse(response);
    } catch (e) {
      return {"status": false, "message": "Request failed: $e"};
    }
  }

  /// 🔹 Helper function to make HTTP requests
  static Future<http.Response> _makeRequest(
      Uri url,
      Map<String, String> headers,
      String method,
      Map<String, dynamic>? requestBody) async {
    switch (method.toUpperCase()) {
      case "POST":
        return await http.post(url,
            headers: headers, body: jsonEncode(requestBody));
      case "GET":
        return await http.get(url, headers: headers);
      case "PUT":
        return await http.put(url,
            headers: headers, body: jsonEncode(requestBody));
      case "DELETE":
        return await http.delete(url, headers: headers);
      default:
        throw Exception("Invalid HTTP method: $method");
    }
  }

  /// 🔹 Helper function to process API response
  static dynamic _handleResponse(http.Response response) {
    try {
      final Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        decodedBody["status"] = true;
        return decodedBody;
      } else {
        return {
          "status": false,
          "message": decodedBody["message"] ?? "Something went wrong"
        };
      }
    } catch (e) {
      return {"status": false, "message": "Invalid JSON response: $e"};
    }
  }
}
