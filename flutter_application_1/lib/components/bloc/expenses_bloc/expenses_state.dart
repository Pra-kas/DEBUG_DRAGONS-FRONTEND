part of 'expenses_bloc.dart';

abstract class ExpensesState {}

abstract class ExpensesActionState extends ExpensesState {}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoadingState extends ExpensesActionState {}

class ExpensesLoadedState extends ExpensesActionState {
  final List<Map<String,dynamic>> expenses;

  ExpensesLoadedState(this.expenses);
}

class ExpensesErrorState extends ExpensesActionState {}

class ExpensesImageProcessingState extends ExpensesActionState {}

class ExpenseImageProcessedState extends ExpensesActionState {
  List<ExpenseModel> expenses;
  ExpenseImageProcessedState(this.expenses);
}
