import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/components/models/expense_model.dart';
import 'package:flutter_application_1/service/upload_bill.dart';
import 'package:image_picker/image_picker.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc() : super(ExpensesInitial()) {
    on<ExpensesInitialEvent> (expensesInitialEvent);
    on<ExpenseImagePickedEvent>(expenseImagePickedEvent);
  }

  List<Map<String,dynamic>> expenseList = [
    {
      "expense_title": "Groceries",
      "amount_spent": 1200,
      "category": "Food",
      "date_time": "2025-03-08T14:30:00",
      "payment_method": "UPI",
      "merchant_name": "Big Bazaar"
    },
    {
      "expense_title": "Electricity Bill",
      "amount_spent": 2500,
      "category": "Utilities",
      "date_time": "2025-03-07T10:00:00",
      "payment_method": "Credit Card",
      "merchant_name": "State Electricity Board"
    },
    {
      "expense_title": "Uber Ride",
      "amount_spent": 350,
      "category": "Transport",
      "date_time": "2025-03-06T18:45:00",
      "payment_method": "Debit Card",
      "merchant_name": "Uber"
    },
    {
      "expense_title": "Movie Tickets",
      "amount_spent": 800,
      "category": "Entertainment",
      "date_time": "2025-03-05T20:00:00",
      "payment_method": "UPI",
      "merchant_name": "PVR Cinemas"
    },
    {
      "expense_title": "Coffee",
      "amount_spent": 150,
      "category": "Food",
      "date_time": "2025-03-04T09:30:00",
      "payment_method": "Cash",
      "merchant_name": "Starbucks"
    },
    {
      "expense_title": "Gym Membership",
      "amount_spent": 3000,
      "category": "Fitness",
      "date_time": "2025-03-03T12:00:00",
      "payment_method": "Credit Card",
      "merchant_name": "Gold's Gym"
    },
    {
      "expense_title": "Online Shopping",
      "amount_spent": 4500,
      "category": "Shopping",
      "date_time": "2025-03-02T15:20:00",
      "payment_method": "Debit Card",
      "merchant_name": "Amazon"
    },
    {
      "expense_title": "Dinner at Restaurant",
      "amount_spent": 1800,
      "category": "Food",
      "date_time": "2025-03-01T21:00:00",
      "payment_method": "UPI",
      "merchant_name": "Barbeque Nation"
    },
    {
      "expense_title": "Mobile Recharge",
      "amount_spent": 399,
      "category": "Utilities",
      "date_time": "2025-02-28T08:00:00",
      "payment_method": "Credit Card",
      "merchant_name": "Jio"
    },
    {
      "expense_title": "Book Purchase",
      "amount_spent": 1200,
      "category": "Education",
      "date_time": "2025-02-27T17:30:00",
      "payment_method": "Debit Card",
      "merchant_name": "Flipkart"
    }
  ];

  Future<void> expenseImagePickedEvent(ExpenseImagePickedEvent event, Emitter<ExpensesState> emit)async{
    emit(ExpensesImageProcessingState());
    await uploadBill(event.image);
    emit(ExpenseImageProcessedState([]));
  }

  Future<void> expensesInitialEvent(ExpensesInitialEvent event, Emitter<ExpensesState> emit) async {
    emit(ExpensesLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    emit(ExpensesLoadedState(expenseList));
  }
}
