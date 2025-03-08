import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/components/models/expense_model.dart';
import 'package:meta/meta.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc() : super(ExpensesInitial()) {
    on<ExpensesInitialEvent> (expensesInitialEvent);
  }

  List<Map<String, dynamic>> expenseList = [
    {
      "expense_title": "Groceries",
      "amount_spent": 1200,
      "category": "Food",
      "date_time": "2025-03-08T14:30:00",
      "payment_method": "UPI",
      "merchant_name": "Big Bazaar",
      "tags": ["essentials", "monthly"],
      "items": [
        {"amountSpent": 500, "title": "Vegetables"},
        {"amountSpent": 300, "title": "Dairy Products"},
        {"amountSpent": 400, "title": "Snacks"}
      ]
    },
    {
      "expense_title": "Electricity Bill",
      "amount_spent": 2500,
      "category": "Utilities",
      "date_time": "2025-03-07T10:00:00",
      "payment_method": "Credit Card",
      "merchant_name": "State Electricity Board",
      "tags": ["monthly", "bills"],
      "items": [
        {"amountSpent": 2.99, "title": "Ut wisi enim"},
        {"amountSpent": 1.3, "title": "Nibh euismod"},
        {"amountSpent": 17, "title": "Rdol magna"},
        {"amountSpent": 6.99, "title": "Mnonuy nibh"},
        {"amountSpent": 1.2, "title": "Kaoreet dolore"},
        {"amountSpent": 5.1, "title": "Taliquam erat"},
        {"amountSpent": 10, "title": "Aeuismod"},
        {"amountSpent": 4.99, "title": "Knonuy nib"}
      ]
    },
    {
      "expense_title": "Uber Ride",
      "amount_spent": 350,
      "category": "Transport",
      "date_time": "2025-03-06T18:45:00",
      "payment_method": "Debit Card",
      "merchant_name": "Uber",
      "tags": ["travel", "daily commute"],
      "items": [
        {"amountSpent": 350, "title": "Ride Fare"}
      ]
    },
    {
      "expense_title": "Movie Tickets",
      "amount_spent": 800,
      "category": "Entertainment",
      "date_time": "2025-03-05T20:00:00",
      "payment_method": "UPI",
      "merchant_name": "PVR Cinemas",
      "tags": ["leisure", "weekend"],
      "items": [
        {"amountSpent": 400, "title": "Ticket 1"},
        {"amountSpent": 400, "title": "Ticket 2"}
      ]
    },
    {
      "expense_title": "Coffee",
      "amount_spent": 150,
      "category": "Food",
      "date_time": "2025-03-04T09:30:00",
      "payment_method": "Cash",
      "merchant_name": "Starbucks",
      "tags": ["snack", "morning"],
      "items": [
        {"amountSpent": 150, "title": "Latte"}
      ]
    },
    {
      "expense_title": "Gym Membership",
      "amount_spent": 3000,
      "category": "Fitness",
      "date_time": "2025-03-03T12:00:00",
      "payment_method": "Credit Card",
      "merchant_name": "Gold's Gym",
      "tags": ["health", "monthly"],
      "items": [
        {"amountSpent": 3000, "title": "Monthly Subscription"}
      ]
    },
    {
      "expense_title": "Online Shopping",
      "amount_spent": 4500,
      "category": "Shopping",
      "date_time": "2025-03-02T15:20:00",
      "payment_method": "Debit Card",
      "merchant_name": "Amazon",
      "tags": ["clothes", "electronics"],
      "items": [
        {"amountSpent": 2000, "title": "T-shirt"},
        {"amountSpent": 2500, "title": "Headphones"}
      ]
    },
    {
      "expense_title": "Dinner at Restaurant",
      "amount_spent": 1800,
      "category": "Food",
      "date_time": "2025-03-01T21:00:00",
      "payment_method": "UPI",
      "merchant_name": "Barbeque Nation",
      "tags": ["weekend", "dining"],
      "items": [
        {"amountSpent": 1800, "title": "Buffet Dinner"}
      ]
    },
    {
      "expense_title": "Mobile Recharge",
      "amount_spent": 399,
      "category": "Utilities",
      "date_time": "2025-02-28T08:00:00",
      "payment_method": "Credit Card",
      "merchant_name": "Jio",
      "tags": ["monthly", "phone"],
      "items": [
        {"amountSpent": 399, "title": "Jio Recharge Plan"}
      ]
    },
    {
      "expense_title": "Book Purchase",
      "amount_spent": 1200,
      "category": "Education",
      "date_time": "2025-02-27T17:30:00",
      "payment_method": "Debit Card",
      "merchant_name": "Flipkart",
      "tags": ["learning", "study"],
      "items": [
        {"amountSpent": 1200, "title": "Data Structures Book"}
      ]
    }
  ];

  Future<void> expensesInitialEvent(ExpensesInitialEvent event, Emitter<ExpensesState> emit) async {
    emit(ExpensesLoadingState());
    await Future.delayed(const Duration(seconds: 1));
    emit(ExpensesLoadedState(expenseList));
  }
}
