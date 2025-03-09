part of 'edit_expense_bloc.dart';

abstract class EditExpenseEvent {}

class EditExpenseSaveEvent extends EditExpenseEvent {
  final Map<String,dynamic> expense;
  bool isEdit;
  EditExpenseSaveEvent({required this.expense, required this.isEdit});
}

class AddIncomeSaveEvent extends EditExpenseEvent {
  final Map<String,dynamic> income;
  AddIncomeSaveEvent({required this.income});
}
