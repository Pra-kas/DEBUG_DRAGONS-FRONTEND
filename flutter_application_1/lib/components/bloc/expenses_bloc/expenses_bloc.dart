import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/components/models/expense_model.dart';
import 'package:flutter_application_1/service/expense_service.dart';
import 'package:image_picker/image_picker.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc() : super(ExpensesInitial()) {
    on<ExpensesInitialEvent> (expensesInitialEvent);
    on<ExpenseImagePickedEvent>(expenseImagePickedEvent);
    on<ExpensePdfPickedEvent>(expensePdfPickedEvent);
    on<ExpenseChoiceShipSelectedEvent>(expenseChoiceShipSelectedEvent);
    on<ExpensechatBotEvent>(expensechatBotEvent);
  }

  Future<void> expensechatBotEvent(ExpensechatBotEvent event, Emitter<ExpensesState> emit) async {
    emit(ExpenseChatBotLoadingState());
    String message = await getChatBotResponse(event.message);
    emit(ExpenseChatBotLoadedState(message));
  }


  Future<void> expenseChoiceShipSelectedEvent(ExpenseChoiceShipSelectedEvent event, Emitter<ExpensesState> emit) async {
    emit(ExpenseChoiceShipSelected(event.choiceShip));
  }


  Future<void> expensePdfPickedEvent(ExpensePdfPickedEvent event, Emitter<ExpensesState> emit)async{
    emit(ExpensePdfProcessingState());
    await uploadPdf(event.pdf);
    dynamic val = await getExpenses();
    List<Map<String,dynamic>> expenses = val["expenses"];
    List<Map<String,dynamic>> recurringExpenses = val["recurringExpenses"];
    emit(ExpensePdfProcessedState(expenses));
  }

  Future<void> expenseImagePickedEvent(ExpenseImagePickedEvent event, Emitter<ExpensesState> emit)async{
    emit(ExpensesImageProcessingState());
    await uploadBill(event.image);
    dynamic val = await getExpenses();
    List<Map<String,dynamic>> expenses = val["expenses"];
    List<Map<String,dynamic>> recurringExpenses = val["recurringExpenses"];
    emit(ExpenseImageProcessedState(expenses));
  }

  Future<void> expensesInitialEvent(ExpensesInitialEvent event, Emitter<ExpensesState> emit) async {
    emit(ExpensesLoadingState());
    dynamic val = await getExpenses();
    List<Map<String,dynamic>> expenses = val["expenses"];
    List<Map<String,dynamic>> recurringExpenses = val["recurringExpenses"];
    emit(ExpensesLoadedState(expenses,recurringExpenses));
  }
}
