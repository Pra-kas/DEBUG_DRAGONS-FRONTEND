import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/models/expense_model.dart';
import 'package:flutter_application_1/components/view/expenses/add_income.dart';
import 'package:flutter_application_1/components/view/expenses/edit_expenses.dart';
import 'package:flutter_application_1/components/widgets/expense_card.dart';
import 'package:flutter_application_1/service/helper/update_expense.dart';
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
  bool isRecurring = false;
  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> recurringExpenses = [];
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
          recurringExpenses = state.recurringExpenses;
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
            forceMaterialTransparency: true,
            title: Text(
              "Expenses",
              style: AppStyles.setAppStyle(black, 20, FontWeight.bold, "black"),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                            "The below displayed expenses are considered as recurring expenses. Please verify them. You can simple add those by clicking on the check icon.",style: TextStyle(fontFamily: "medium"),),
                      ),
                      RecurringExpensesWidget(initialExpenses: recurringExpenses,),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Continue"),
                      )
                    ],
                  );
                });
                },
                icon: Icon(Icons.info,color: primary,),
              )
            ],
            leading: Icon(Icons.money, color: black),
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
                                  "Add Income",
                                  style: TextStyle(
                                      color: Colors.grey, fontFamily: "medium"),
                                )),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddIncome()));
                            },
                          ),
                          ListTile(
                            title: Center(
                                child: Text(
                              "Add Expense",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "medium"),
                            )),
                            onTap: () {
                              Navigator.pop(context);
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
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context)
                              .viewInsets
                              .bottom, // Moves content up
                        ),
                        child: ChatBotBottomSheet(expensesBloc: expensesBloc),
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
        : (expenses.isNotEmpty) ? ListView.builder(
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
          ) : Center(child : Text("No expenses found"));
  }
}

class ChatBotBottomSheet extends StatefulWidget {
  final ExpensesBloc expensesBloc;

  const ChatBotBottomSheet({
    required this.expensesBloc,
    super.key,
  });

  @override
  State<ChatBotBottomSheet> createState() => _ChatBotBottomSheetState();
}

class _ChatBotBottomSheetState extends State<ChatBotBottomSheet> {
  String? selectedChip;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final messages = [];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> chipLabels = [
      "Financial Insights",
      "Budgeting Assistance",
      "Expense Tracking",
      "Others"
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: BlocBuilder<ExpensesBloc, ExpensesState>(
          bloc: widget.expensesBloc,
          builder: (context, state) {
            if (state is ExpenseChoiceShipSelected) {
              selectedChip = state.choiceShip;
            }

            // Auto-scroll to bottom when new messages arrive
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });

            // Clear text controller after response is received
            if (state is ExpenseChatBotLoadedState) {
              _controller.clear();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar at the top
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Title with an icon
                Row(
                  children: [
                    Icon(
                      Icons.support_agent,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Finance Assistant",
                      style: TextStyle(
                        fontFamily: "medium",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Chat topic chips in a horizontally scrollable container
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: chipLabels.map((label) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          selected: selectedChip == label,
                          label: Text(label),
                          labelStyle: TextStyle(
                            fontWeight: selectedChip == label
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          backgroundColor: Colors.grey.shade200,
                          selectedColor:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          onSelected: (value) {
                            setState(() {
                              if (selectedChip == label) {
                                selectedChip = null;
                                _controller.clear();
                              } else {
                                selectedChip = label;
                                // Set the text controller to the chip label
                                if (label != "Others") {
                                  _controller.text = label;
                                } else {
                                  _controller.clear();
                                }
                              }
                            });

                            widget.expensesBloc.add(
                                ExpenseChoiceShipSelectedEvent(
                                    selectedChip ?? ""));
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // Chat messages area
                Flexible(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state is ExpenseChatBotLoadedState)
                          ChatBubble(
                            message: state.message,
                            isFromBot: true,
                          ),
                        if (state is ExpenseChatBotLoadingState)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: SpinKitPulse(
                                color: Theme.of(context).primaryColor,
                                size: 40.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Input field with send button - always visible
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      width: 1.5,
                    ),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Type your question here...",
                            hintStyle: TextStyle(
                              fontFamily: "medium",
                              color: Colors.grey.shade500,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            if (_controller.text.isNotEmpty) {
                              // Send message to bloc and wait for response
                              widget.expensesBloc
                                  .add(ExpensechatBotEvent(_controller.text));
                              // Controller will be cleared after response is received
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.send_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Custom chat bubble widget
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isFromBot;

  const ChatBubble({
    required this.message,
    required this.isFromBot,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isFromBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isFromBot)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.2),
                radius: 16,
                child: Icon(
                  Icons.android,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isFromBot
                    ? Colors.grey.shade100
                    : Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isFromBot
                      ? Colors.grey.shade300
                      : Theme.of(context).primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecurringExpensesWidget extends StatefulWidget {
  final List<Map<String, dynamic>> initialExpenses;

  const RecurringExpensesWidget({Key? key, required this.initialExpenses}) : super(key: key);

  @override
  _RecurringExpensesWidgetState createState() => _RecurringExpensesWidgetState();
}

class _RecurringExpensesWidgetState extends State<RecurringExpensesWidget> {
  late List<Map<String, dynamic>> recurringExpenses;

  @override
  void initState() {
    super.initState();
    recurringExpenses = List.from(widget.initialExpenses);
  }

  void removeItem(int index, bool canSend) {
    if (index >= 0 && index < recurringExpenses.length) {
      createExpense(recurringExpenses[index]);
      setState(() {
        recurringExpenses.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recurringExpenses.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> expense = entry.value;
        return Card(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            title: Text(
              expense['expense_title'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Text("Amount: ${expense['amount_spent']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () => removeItem(index,true),
                ),
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => removeItem(index,false),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

