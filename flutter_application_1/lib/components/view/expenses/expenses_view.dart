import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/widgets/expense_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../theme/colors.dart';
import '../../bloc/expenses_bloc/expenses_bloc.dart';
import '../../utils/helper/styles.dart';

class ExpensesView extends StatefulWidget {
  const ExpensesView({super.key});

  @override
  State<ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
  bool initialLoading = true;
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
        }
        if (state is ExpensesErrorState) {
          initialLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("something went wrong")));
        }
      },
      builder: (context, state) {
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
          floatingActionButton: ElevatedButton(
              onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: white,
              shape: CircleBorder(
                side: BorderSide(color: border, width: 0.5)
              ),
              minimumSize: const Size(50, 50),
            ),
              child: Icon(Icons.star,size: 35,color: Colors.green,),
          ),
          body: bodyPartOfExpensesView(),
        );
      },
    );
  }

  Widget bodyPartOfExpensesView() {
    return initialLoading
        ? Center(child: SpinKitCircle(color: primary,))
        : ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: expensesBloc.expenseList.length,
      itemBuilder: (context, index) {
        return ExpenseCard(
            expenseTitle: expensesBloc.expenseList[index]["expense_title"],
            amountSpent: expensesBloc.expenseList[index]["amount_spent"],
            category: expensesBloc.expenseList[index]["category"],
            dateTime: expensesBloc.expenseList[index]["date_time"],
            paymentMethod: expensesBloc.expenseList[index]["payment_method"],
            merchantName: expensesBloc.expenseList[index]["merchant_name"],
          expenseData: expensesBloc.expenseList[index],
        );
      },
    );
  }
}
