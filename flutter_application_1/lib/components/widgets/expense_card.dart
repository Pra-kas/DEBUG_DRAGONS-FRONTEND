import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/view/expenses/edit_expenses.dart';
import 'package:intl/intl.dart';

import '../../theme/colors.dart';

class ExpenseCard extends StatelessWidget {
  final String expenseTitle;
  final int amountSpent;
  final String category;
  final String dateTime; // Accept date as String from JSON
  final String paymentMethod;
  final String merchantName;
  final Map<String, dynamic> expenseData;

  const ExpenseCard({
    super.key,
    required this.expenseTitle,
    required this.amountSpent,
    required this.category,
    required this.dateTime,
    required this.paymentMethod,
    required this.merchantName,
    required this.expenseData,
  });

  @override
  Widget build(BuildContext context) {
    // Safely parse the date string to DateTime
    DateTime parsedDate = DateTime.tryParse(dateTime) ?? DateTime.now();

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => EditExpenseScreen(expenseData: expenseData, isEdit: true,)));
      },
      child: Card(
        color: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: border, width: 0.5)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon for category (currently hardcoded for movies)
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.movie, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),

              // Expense details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expenseTitle,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      merchantName,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat.yMMMd().format(parsedDate)} • ${DateFormat.jm().format(parsedDate)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Amount spent
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹$amountSpent',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    paymentMethod,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
