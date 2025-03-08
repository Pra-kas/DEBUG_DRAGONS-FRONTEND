part of 'expenses_bloc.dart';

abstract class ExpensesEvent {}

class ExpensesInitialEvent extends ExpensesEvent {}

class ExpenseImagePickedEvent extends ExpensesEvent {
  final XFile image;
  ExpenseImagePickedEvent(this.image);
}

class ExpensePdfPickedEvent extends ExpensesEvent {
  final FilePickerResult pdf;
  ExpensePdfPickedEvent(this.pdf);
}