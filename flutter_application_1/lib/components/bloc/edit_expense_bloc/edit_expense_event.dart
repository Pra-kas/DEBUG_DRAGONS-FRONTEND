part of 'edit_expense_bloc.dart';

abstract class EditExpenseEvent {}

class EditExpenseSaveEvent extends EditExpenseEvent {
  final Map<String,dynamic> expense;
  EditExpenseSaveEvent({required this.expense});
}
