import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/service/helper/global_service.dart';
import 'package:flutter_application_1/service/helper/update_expense.dart';
import 'package:meta/meta.dart';

part 'edit_expense_event.dart';
part 'edit_expense_state.dart';

class EditExpenseBloc extends Bloc<EditExpenseEvent, EditExpenseState> {
  EditExpenseBloc() : super(EditExpenseInitial()) {
    on<EditExpenseSaveEvent> (editExpenseSaveEvent);
  }

  Future<void> editExpenseSaveEvent(EditExpenseSaveEvent event, Emitter<EditExpenseState> emit) async {
    emit(EditExpenseSavingState());
    Map<String,dynamic> expense = event.expense;
    print("expense ${expense} bool : ${event.isEdit}");
    // do api call here
    if (event.isEdit) {
      bool isUpdated = await updateExpense(expense);
      print("bool : $isUpdated");
      if (isUpdated) {
        emit(EditExpenseSavedState());
      } else  {
        emit(EditExpenseErrorState());
      }
    } else {
      bool isCreated = await createExpense(expense);
      if (isCreated) {
        emit(EditExpenseSavedState());
      } else  {
        emit(EditExpenseErrorState());
      }
    }
  }
}
