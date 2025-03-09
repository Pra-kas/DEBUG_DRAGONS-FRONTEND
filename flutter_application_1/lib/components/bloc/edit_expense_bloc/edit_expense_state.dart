part of 'edit_expense_bloc.dart';

abstract class EditExpenseState {}

abstract class EditExpenseActionState extends EditExpenseState {}

class EditExpenseInitial extends EditExpenseState {}

class EditExpenseSavedState extends EditExpenseActionState {}

class EditExpenseSavingState extends EditExpenseActionState {}

class EditExpenseErrorState extends EditExpenseActionState {}