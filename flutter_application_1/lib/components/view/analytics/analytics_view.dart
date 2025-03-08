import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/components/bloc/AnalyticsBloc/analytics_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/colors.dart';
import '../../utils/helper/styles.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView>
    with TickerProviderStateMixin {
  List<int> xAxis = [];
  List<String> month = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<String> barTouchData = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<int> yAxis = [];
  String xTitle = "";
  String yTitle = "";
  late TabController tabController;
  final analyticsBlocBloc = AnalyticsBlocBloc();
  int selectedMonth = -1;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    analyticsBlocBloc.add(AnalyticsLoadEvent());
    barTouchData = month;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analytics',
          style: AppStyles.setAppStyle(black, 20, FontWeight.bold, 'black'),
        ),
        centerTitle: true,
        forceMaterialTransparency: true,
        leading: SizedBox(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AnalyticsBlocBloc, AnalyticsBlocState>(
          bloc: analyticsBlocBloc,
          builder: (context, state) {
            if (state is AnalyticsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AnalyticsLoadedState) {
              xAxis = state.xList;
              yAxis = state.yList;
              xTitle = state.xTitle;
              yTitle = state.yTitle;
              selectedMonth = state.selectedMonth;

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < 12; i++)
                            monthlyExpenseContainer(
                                value: state.yList[i],
                                month: month[i],
                                expense: state.yList[i],
                                income: state.yList[i] + 500,
                                index: i,
                                isSelected: selectedMonth == i,
                                onTap: () {
                                  analyticsBlocBloc.add(AnalyticsMonthSelectedEvent(i));
                                }
                            )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Show weekly data if a month is selected, otherwise show monthly data
                    if (selectedMonth >= 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${month[selectedMonth]} Weekly Analytics',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                analyticsBlocBloc.add(AnalyticsMonthSelectedEvent(-1));
                              },
                              child: const Text('Back to Monthly View',style: TextStyle(overflow: TextOverflow.ellipsis),),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      weeklyExpenseGraph(
                          context,
                          List.generate(4, (index) => index),
                          state.weeklyData[selectedMonth] ?? [],
                          "Weeks",
                          "Weekly Amount",
                          selectedMonth
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < 4; i++)
                              weeklyDetailContainer(
                                week: "Week ${i + 1}",
                                expense: state.weeklyExpense[selectedMonth]?[i] ?? 0,
                                income: state.weeklyIncome[selectedMonth]?[i] ?? 0,
                              )
                          ],
                        ),
                      ),
                    ] else ...[
                      const Text('Expense Graphs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      expenseGraph(context, xAxis, yAxis, xTitle, yTitle, month),
                    ],

                    // const SizedBox(height: 20),
                    // TabBar(
                    //     controller: tabController,
                    //     dividerColor: Colors.transparent,
                    //     tabs: const [
                    //       Tab(child: Text("Expenses")),
                    //       Tab(child: Text("Stocks"))
                    //     ]
                    // ),
                  ],
                ),
              );
            }
            return const Center(child: Text("No data available"));
          },
        ),
      ),
    );
  }
}

Widget monthlyExpenseContainer({
  required int value,
  required String month,
  required int expense,
  required int income,
  required int index,
  required bool isSelected,
  required VoidCallback onTap
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      color: isSelected ? Colors.blue[100] : Colors.grey[200],
      elevation: isSelected ? 4 : 1,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(month, style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Expense'),
                Text('₹$expense'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Income'),
                Text('₹$income'),
              ],
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('Tap to view weekly', style: TextStyle(fontSize: 12, color: Colors.blue)),
              ),
          ],
        ),
      ),
    ),
  );
}

Widget weeklyDetailContainer({
  required String week,
  required int expense,
  required int income,
}) {
  return Card(
    color: Colors.grey[200],
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(week, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Expense'),
              Text('₹$expense'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Income'),
              Text('₹$income'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Balance'),
              Text('₹${income - expense}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: income - expense >= 0 ? Colors.green : Colors.red
                  )),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget expenseGraph(BuildContext context, List<int> xList, List<int> yList,
    String xTitle, String yTitle, List<String> month) {
  return SizedBox(
    height: MediaQuery.of(context).size.width * 0.9,
    child: BarChart(BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        groupsSpace: 12,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                  month[group.x.toInt()],
                  const TextStyle(color: Colors.white));
            },
          ),
        ),
        barGroups: [
          for (int i = 0; i < xList.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: yList[i].toDouble(),
                  fromY: 0,
                  width: 25,
                  color: Colors.blue,
                ),
              ],
              barsSpace: 4,
            ),
        ],
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: Text(yTitle),
              sideTitles: const SideTitles(showTitles: false, reservedSize: 30),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(xTitle),
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < month.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(month[value.toInt()].substring(0, 3)),
                      );
                    }
                    return const Text('');
                  },
                  reservedSize: 30
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            )))),
  );
}

Widget weeklyExpenseGraph(BuildContext context, List<int> xList, List<int> yList,
    String xTitle, String yTitle, int monthIndex) {
  print("ylist data ${yList[1].toDouble()}");
  return SizedBox(
    height: MediaQuery.of(context).size.width * 0.7,
    child: BarChart(BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        groupsSpace: 12,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                  "Week ${group.x.toInt() + 1}",
                  const TextStyle(color: Colors.white));
            },
          ),
        ),
        barGroups: [
          for (int i = 0; i < xList.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: yList[i].toDouble(),
                  fromY: 0,
                  width: 30,
                  color: Colors.green,
                ),
              ],
              barsSpace: 4,
            ),
        ],
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: Text(yTitle),
              sideTitles: const SideTitles(showTitles: false, reservedSize: 30),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(xTitle),
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("Week ${value.toInt() + 1}"),
                    );
                  },
                  reservedSize: 30
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            )))),
  );
}