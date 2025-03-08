
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/utils/helper/styles.dart';
import 'package:flutter_application_1/theme/colors.dart';

class ViewExpense extends StatefulWidget {
  Map<String, dynamic> expenseModel;
  ViewExpense({super.key, required this.expenseModel});

  @override
  State<ViewExpense> createState() => _ViewExpenseState();
}

class _ViewExpenseState extends State<ViewExpense> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          "View Expenses",
          style: AppStyles.setAppStyle(black, 29, FontWeight.bold, "bold"),
        ),
      ),
      body: bodyPartOfViewExpense(),
    );
  }

  Widget bodyPartOfViewExpense() {
    return SizedBox();
  }
}
