import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/bloc/edit_expense_bloc/edit_expense_bloc.dart';
import 'package:flutter_application_1/components/utils/helper/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../../theme/colors.dart';
import '../../bloc/expenses_bloc/expenses_bloc.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {

  TextEditingController amountController = TextEditingController();
  TextEditingController incomeTitleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  EditExpenseBloc expensesBloc = EditExpenseBloc();
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditExpenseBloc, EditExpenseState>(
      bloc: expensesBloc,
      listener: (context, state) {
        if (state is EditExpenseSavedState) {
          isSaving = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Income added successfully"),
              backgroundColor: primary,
            ),
          );
          Navigator.pop(context);
        }
        if (state is EditExpenseErrorState) {
          isSaving = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error in adding income"),
              backgroundColor: primary,
            ),
          );
        }
        if (state is EditExpenseSavingState) {
          isSaving = true;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            title: Text(
              "Add Income",
              style: AppStyles.setAppStyle(black, 20, FontWeight.bold, "black"),
            ),
          ),
          body: bodyPartOfIncome(),
        );
      },
    );
  }

  Widget bodyPartOfIncome() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          textFieldForCreateScreen(
              "Income Title (source)", incomeTitleController),
          textFieldForCreateScreen("Salary amount", amountController),
          dateWidget(),
          isSaving ? SpinKitCircle(color: primary,) : ElevatedButton(
            onPressed: () {
              Map<String,dynamic> incomeData = {
                "expense_title": incomeTitleController.text,
                "merchant_name" : "",
                "amount_spent": amountController.text,
                "date": dateController.text,
                "category": "income",
                "payment_method": "salary",
              };
              expensesBloc.add(AddIncomeSaveEvent(income: incomeData));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Add income", style: AppStyles.setAppStyle(
                white, 16, FontWeight.normal, "medium"),),
          ),
        ],
      ),
    );
  }


  Widget dateWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12.0, vertical: 16.0),
        decoration: BoxDecoration(
            color: filterSortBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: border)),
        child: InkWell(
          enableFeedback: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate:
              (dateController.text.isNotEmpty)
                  ? DateTime
                  .parse(dateController.text)
                  : DateTime.now(),
              firstDate: DateTime(2000), lastDate: DateTime(2050),
            );
            if (pickedDate != null) {
              setState(() {
                dateController.text =
                    DateFormat('dd-MM-yyyy')
                        .format(pickedDate);
              });
            }
          },
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateController.text.isNotEmpty
                    ? dateController.text
                    : 'dd-mm-yyyy',
                style: const TextStyle(
                  fontFamily: 'medium',
                  color: Colors.grey,
                ),
              ),
              Icon(Icons.calendar_month)
            ],
          ),
        ),
      ),
    );
  }

  Widget textFieldForCreateScreen(String labelText,
      TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        keyboardType: (labelText == "Salary amount")
            ? TextInputType.number
            : TextInputType.text,
        controller: textEditingController,
        style: const TextStyle(fontFamily: "regular"),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: primary,
                  width: 0.5
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: primary,
                  width: 0.5
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: primary,
                  width: 0.5
              ),
            ),
            labelText: labelText,
            labelStyle: TextStyle(
              fontFamily: "regular",
              color: grey,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
            floatingLabelStyle: TextStyle(
              fontFamily: "regular",
              color: primary,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
            fillColor: white,
            filled: true),
        maxLines: 10,
        minLines: 1,
      ),
    );
  }
}
