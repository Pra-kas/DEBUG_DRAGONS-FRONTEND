part of 'expenses_bloc.dart';

abstract class ExpensesState {}

abstract class ExpensesActionState extends ExpensesState {}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoadingState extends ExpensesActionState {}

class ExpensesLoadedState extends ExpensesActionState {
  final List<Map<String,dynamic>> expenses;
  final List<Map<String,dynamic>> recurringExpenses;

  ExpensesLoadedState(this.expenses,this.recurringExpenses);
}

class ExpensesErrorState extends ExpensesActionState {}

class ExpensesImageProcessingState extends ExpensesActionState {}

class ExpenseImageProcessedState extends ExpensesActionState {
  List<Map<String,dynamic>> expenses;
  ExpenseImageProcessedState(this.expenses);
}

class ExpensePdfProcessingState extends ExpensesActionState {}

class ExpensePdfProcessedState extends ExpensesActionState {
  List<Map<String,dynamic>> expenses;
  ExpensePdfProcessedState(this.expenses);
}

class ExpenseChoiceShipSelected extends ExpensesActionState {
  final String choiceShip;
  ExpenseChoiceShipSelected(this.choiceShip);
}

class ExpenseChatBotLoadingState extends ExpensesActionState {}

class ExpenseChatBotLoadedState extends ExpensesActionState {
  final String message;
  ExpenseChatBotLoadedState(this.message);
}
