import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/utils/helper/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../../theme/colors.dart';
import '../../bloc/edit_expense_bloc/edit_expense_bloc.dart';

class EditExpenseScreen extends StatefulWidget {
  final Map<String, dynamic> expenseData;
  final bool isEdit;

  const EditExpenseScreen({super.key, required this.expenseData, required this.isEdit});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController expenseTitleController = TextEditingController();
  TextEditingController merchantNameController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController paymentMethodController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  List<Map<String, dynamic>> items = [];
  String selectedCategory = "Shopping";
  String selectedPaymentMethod = "Cash";
  DateTime? selectedDate;
  EditExpenseBloc editExpenseBloc = EditExpenseBloc();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    print("AMount spent : ${widget.expenseData["date_time"]}");
    if (widget.isEdit) {
      expenseTitleController =
          TextEditingController(text: widget.expenseData["expense_title"] ?? "");
      categoryController = TextEditingController(text: widget.expenseData["category"] ?? "");
      paymentMethodController = TextEditingController(text: widget.expenseData["payment_method"] ?? "");
      merchantNameController = TextEditingController(text: widget.expenseData["merchant_name"] ?? "");
      totalAmountController = TextEditingController(text: widget.expenseData["amount_spent"].toString() ?? "");
      dateController = TextEditingController(text: widget.expenseData["date_time"] ?? "");
      selectedDate = widget.expenseData["date_time"] != null
          ? DateTime.tryParse(widget.expenseData["date_time"])
          : null;
      print("tags from josn : ${widget.expenseData["tags"]}");
      items = List<Map<String, dynamic>>.from(widget.expenseData["items"] ?? []);
    }
  }

  @override
  void dispose() {
    expenseTitleController.dispose();
    merchantNameController.dispose();
    totalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEdit ? "Edit Expense" : "Create Expense",style: AppStyles.setAppStyle(black, 20, FontWeight.bold, "black"),)),
      body: bodyPartOfEditExpense(),
    );
  }

  Widget bodyPartOfEditExpense() {
    return BlocConsumer<EditExpenseBloc, EditExpenseState>(
      bloc: editExpenseBloc,
  listener: (context, state) {
    if (state is EditExpenseSavingState) {
      isSaving = true;
    }
    if (state is EditExpenseSavedState) {
      isSaving = false;
      Navigator.pop(context);
    }
    if (state is EditExpenseErrorState) {
      isSaving = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error while saving expense"),
        ),
      );
    }
  },
  builder: (context, state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          textFieldForCreateScreen("Expense Title", expenseTitleController),
          textFieldForCreateScreen("Merchant Name", merchantNameController),
          textFieldForCreateScreen("Payment Method", paymentMethodController),
          dateWidget(),
          textFieldForCreateScreen("Category", categoryController),
          const SizedBox(height: 20),
          const Text("Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return itemRow(index);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      items.add({
                        "title": "",
                        "amount_spent": 0.0,
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Add Item", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          isSaving
              ?  Center(
            child : SpinKitCircle(
              color: primary,
            ),
          )
              :
          ElevatedButton(
            onPressed: () {
              if (true) {
                for (int i=0;i<items.length;i++) {
                  items[i] = {
                    "title": items[i]['title'],
                    "amount_spent": items[i]['amount_spent'],
                  };
                }
                Map<String,dynamic> expenseData = widget.isEdit ? {
                  "expense_title": expenseTitleController.text,
                  "merchant_name": merchantNameController.text,
                  "amount_spent": -double.parse(totalAmountController.text),
                  "payment_method": paymentMethodController.text,
                  "date_time": dateController.text.trim(),
                  "category": selectedCategory,
                  "items": items,
                  "uuid" : widget.expenseData["uuid"],
                } : {
                  "expense_title": expenseTitleController.text,
                  "merchant_name": merchantNameController.text,
                  "amount_spent": -double.parse(totalAmountController.text),
                  "payment_method": paymentMethodController.text,
                  "date_time": dateController.text.trim(),
                  "category": selectedCategory,
                  "items": items,
                };

                if (widget.isEdit) {
                  editExpenseBloc.add(EditExpenseSaveEvent(expense : expenseData, isEdit: true));
                } else {
                  // Add new expense
                  editExpenseBloc.add(EditExpenseSaveEvent(expense : expenseData, isEdit: false));
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(widget.isEdit ? "Update Expense" : "Add Expense",style: AppStyles.setAppStyle(white, 16, FontWeight.normal, "medium"),),
          ),
        ],
      ),
    );
  },
);
  }

  Widget itemRow(int index) {
    TextEditingController titleController = TextEditingController(text: items[index]['title']);
    TextEditingController amountController = TextEditingController(text: items[index]['amount_spent'].toString());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: titleController,
              onChanged: (value) => items[index]['title'] = value,
              decoration: InputDecoration(labelText: 'Item Title'),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              onChanged: (value) => items[index]['amount_spent'] = double.tryParse(value) ?? 0.0,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                items.removeAt(index);
              });
            },
          )
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

  Widget textFieldForCreateScreen(
      String labelText,
      TextEditingController textEditingController) {
      return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        keyboardType: (labelText == "Amount Spent")
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
