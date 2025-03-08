import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/components/bloc/AnalyticsBloc/analytics_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: const Text(
          'Analytics',
        ),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AnalyticsBlocBloc, AnalyticsBlocState>(
          bloc: analyticsBlocBloc,
          builder: (context, state) {
            if (state is AnalyticsLoadingState) {
              return CircularProgressIndicator();
            }
            if (state is AnalyticsLoadedState) {
              xAxis = state.xList;
              yAxis = state.yList;
              xTitle = state.xTitle;
              yTitle = state.yTitle;
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 12; i++)
                        monthlyExpenseContainer(1000, month[i], i, i)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Expense Graphs'),
                const SizedBox(
                  height: 20,
                ),
                expenseGraph(context, xAxis, yAxis, xTitle, yTitle,month),
                const SizedBox(
                  height: 20,
                ),
                TabBar(
                controller: tabController, 
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(child: Text("Expenses")),
                  Tab(child: Text("Stocks"))
                ]),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget monthlyExpenseContainer(
    int value, String month, int expense, int income) {
  return GestureDetector(
    onTap: () {
    },
    child: Card(
      color: Colors.grey[200],
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(month,style: TextStyle(fontWeight: FontWeight.bold),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Expense'),
                Text('$expense'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Income'),
                Text('$income'),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget expenseGraph(BuildContext context, List<int> xList, List<int> yList,
    String xTitle, String yTitle, List<String>month) {
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
                  TextStyle(color: Colors.white));
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
                ),
              ],
              barsSpace: 4,
            ),
        ],
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: Text(yTitle),
              sideTitles: SideTitles(showTitles: false, reservedSize: 30),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(yTitle),
              sideTitles: SideTitles(showTitles: false, reservedSize: 30),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            )))),
  );
}
