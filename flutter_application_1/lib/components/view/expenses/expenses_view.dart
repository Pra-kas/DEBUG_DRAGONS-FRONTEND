import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/models/expense_model.dart';
import 'package:flutter_application_1/components/view/expenses/edit_expenses.dart';
import 'package:flutter_application_1/components/widgets/expense_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../theme/colors.dart';
import '../../bloc/expenses_bloc/expenses_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/helper/styles.dart';

class ExpensesView extends StatefulWidget {
  const ExpensesView({super.key});

  @override
  State<ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
  bool initialLoading = true;
  List<Map<String, dynamic>> expenses = [];
  ExpensesBloc expensesBloc = ExpensesBloc();

  @override
  void initState() {
    expensesBloc.add(ExpensesInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpensesBloc, ExpensesState>(
      bloc: expensesBloc,
      listener: (context, state) {
        if (state is ExpensesLoadingState) {
          initialLoading = true;
        }
        if (state is ExpensesLoadedState) {
          initialLoading = false;
          expenses = state.expenses;
        }
        if (state is ExpensesErrorState) {
          initialLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("something went wrong")));
        }
      },
      builder: (context, state) {
        if (state is ExpensesImageProcessingState ||
            state is ExpensePdfProcessingState) {
          return SpinKitCircle(
            color: primary,
          );
        }
        if (state is ExpenseImageProcessedState) {
          expenses = state.expenses;
        }
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            title: Text(
              "Expenses",
              style: AppStyles.setAppStyle(black, 20, FontWeight.bold, "black"),
            ),
            leading: SizedBox(),
          ),
          floatingActionButton:
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Wrap(
                        children: [
                          ListTile(
                            title: Center(
                                child: Text(
                              "Add Expense",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "medium"),
                            )),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditExpenseScreen(
                                            expenseData: {},
                                            isEdit: false,
                                          )));
                            },
                          ),
                          ListTile(
                            title: Center(
                                child: Text(
                              "Upload Image",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "medium"),
                            )),
                            onTap: () async {
                              final value = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (value != null) {
                                expensesBloc
                                    .add(ExpenseImagePickedEvent(value));
                                Navigator.pop(context);
                                print(value.path);
                              }
                            },
                          ),
                          ListTile(
                            title: Center(
                                child: Text(
                              "Upload pdf",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "medium"),
                            )),
                            onTap: () async {
                              final value = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf']);
                              if (value != null) {
                                expensesBloc.add(ExpensePdfPickedEvent(value));
                                print(value);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      );
                    });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: white,
                shape:
                    CircleBorder(side: BorderSide(color: border, width: 0.5)),
                minimumSize: const Size(50, 50),
              ),
              child: Icon(
                Icons.add,
                size: 35,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return chatBotBottomSheet(
                        expensesBloc: expensesBloc,
                      );
                    });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: white,
                shape:
                    CircleBorder(side: BorderSide(color: border, width: 0.5)),
                minimumSize: const Size(50, 50),
              ),
              child: Icon(
                Icons.star,
                size: 35,
                color: Colors.green,
              ),
            ),
          ]),
          body: bodyPartOfExpensesView(expenses),
        );
      },
    );
  }

  Widget bodyPartOfExpensesView(List<Map<String, dynamic>> expenses) {
    return initialLoading
        ? Center(
            child: SpinKitCircle(
            color: primary,
          ))
        : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              return ExpenseCard(
                expenseTitle: expenses[index]["expense_title"],
                amountSpent: expenses[index]["amount_spent"],
                category: expenses[index]["category"],
                dateTime: expenses[index]["date_time"],
                paymentMethod: expenses[index]["payment_method"],
                merchantName: expenses[index]["merchant_name"],
                expenseData: expenses[index],
              );
            },
          );
  }
}

class chatBotBottomSheet extends StatelessWidget {
  final ExpensesBloc expensesBloc;
  chatBotBottomSheet({
    required this.expensesBloc,
    super.key,
  });

  String? selectedChip;
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<String> chipLabels = [
      "Financial Insights",
      "Budgeting Assistance",
      "Expense Tracking",
      "Others"
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<ExpensesBloc, ExpensesState>(
        bloc: expensesBloc,
        builder: (context, state) {
          if (state is ExpenseChoiceShipSelected) {
            selectedChip = state.choiceShip;
          }

          List<Widget> columnValues = [
            const SizedBox(height: 20),
            Text(
              "How can I help you ???",
              style: TextStyle(fontFamily: "medium", fontSize: 20),
            ),
            const SizedBox(height: 20),
            if (selectedChip == "Others")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if( (_controller.text.isNotEmpty)) {
                            expensesBloc
                              .add(ExpensechatBotEvent(_controller.text));
                          }
                        }),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary, width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary, width: 0.5),
                    ),
                    border: InputBorder.none,
                    hintText: "Type your message here",
                    hintStyle: TextStyle(fontFamily: "medium"),
                    prefixIcon: Icon(Icons.info),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Wrap(
              children: chipLabels.map((label) {
                return ChoiceChip(
                  selected: selectedChip == label,
                  label: Text(label),
                  onSelected: (value) {
                    if (selectedChip == label) {
                      selectedChip = null;
                    } else {
                      if (label != "Others")
                        expensesBloc.add(ExpensechatBotEvent(label));
                      selectedChip = label;
                    }
                    expensesBloc.add(
                        ExpenseChoiceShipSelectedEvent(selectedChip ?? ""));
                  },
                );
              }).toList(),
            ),
          ];
          if (state is ExpenseChatBotLoadedState) {
            columnValues.add(Card(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(state.message),
            )));
          }
          if (state is ExpenseChatBotLoadingState) {
            columnValues.add(SpinKitCircle(
              color: primary,
            ));
          }
          return Column(children: columnValues);
        },
      ),
    );
  }
}
