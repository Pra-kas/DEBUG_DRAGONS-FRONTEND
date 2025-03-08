import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'edit_expense_event.dart';
part 'edit_expense_state.dart';

class EditExpenseBloc extends Bloc<EditExpenseEvent, EditExpenseState> {
  EditExpenseBloc() : super(EditExpenseInitial()) {
    on<EditExpenseSaveEvent> (editExpenseSaveEvent);
  }

  FutureOr<void> editExpenseSaveEvent(EditExpenseSaveEvent event, Emitter<EditExpenseState> emit) {
    emit(EditExpenseSavingState());
    Map<String,dynamic> expense = event.expense;
    print(expense);
    // do api call here
    emit(EditExpenseSavedState());
  }
}
