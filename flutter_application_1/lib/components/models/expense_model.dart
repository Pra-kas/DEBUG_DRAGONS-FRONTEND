import 'dart:convert';

class ExpenseModel {
  String expenseTitle;
  int amountSpent;
  String category;
  DateTime dateTime;
  String paymentMethod;
  String merchantName;

  ExpenseModel({
    required this.expenseTitle,
    required this.amountSpent,
    required this.category,
    required this.dateTime,
    required this.paymentMethod,
    required this.merchantName,
  });

  // Convert JSON to Expense object
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      expenseTitle: json['expenseTitle'],
      amountSpent: json['amountSpent'],
      category: json['category'],
      dateTime: DateTime.parse(json['dateTime']),
      paymentMethod: json['paymentMethod'],
      merchantName: json['merchantName'],
    );
  }

  // Convert Expense object to JSON
  Map<String, dynamic> toJson() {
    return {
      'expenseTitle': expenseTitle,
      'amountSpent': amountSpent,
      'category': category,
      'dateTime': dateTime.toIso8601String(),
      'paymentMethod': paymentMethod,
      'merchantName': merchantName,
    };
  }

  // Convert list of JSON to List<Expense>
  static List<ExpenseModel> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => ExpenseModel.fromJson(json)).toList();
  }

  // Convert List<Expense> to JSON string
  static String toJsonList(List<ExpenseModel> expenses) {
    final List<Map<String, dynamic>> jsonList = expenses.map((e) => e.toJson()).toList();
    return json.encode(jsonList);
  }
}
