import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/AnalyticsBloc/analytics_bloc_bloc.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView>
    with TickerProviderStateMixin {
  final analyticsBloc = AnalyticsBlocBloc();
  int selectedMonthIndex = 0;
  List<int> xAxis = [];
  List<int> yAxis = [];
  String xTitle = "";
  String yTitle = "";

  List<String> months = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  @override
  void initState() {
    super.initState();
    analyticsBloc.add(AnalyticsLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AnalyticsBlocBloc, AnalyticsBlocState>(
          bloc: analyticsBloc,
          builder: (context, state) {
            if (state is AnalyticsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AnalyticsLoadedState) {
              xAxis = state.xList;
              yAxis = state.yList;
              xTitle = state.xTitle;
              yTitle = state.yTitle;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Month Selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(12, (index) {
                      return monthlyExpenseContainer(
                        month: months[index],
                        expense: yAxis[index],
                        isSelected: selectedMonthIndex == index,
                        onTap: () {
                          setState(() {
                            selectedMonthIndex = index;
                          });
                        },
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Expense Graphs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                // Expense Graph
                expenseGraph(context, xAxis, yAxis, xTitle, yTitle,months),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Monthly Expense Container Widget
Widget monthlyExpenseContainer({
  required String month,
  required int expense,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      color: isSelected ? Colors.blue[100] : Colors.grey[200],
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(month, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Expense:'),
              Text('₹$expense', style: const TextStyle(fontWeight: FontWeight.bold)),
            ]),
          ],
        ),
      ),
    ),
  );
}

// Expense Graph Widget
Widget expenseGraph(BuildContext context, List<int> xList, List<int> yList, String xTitle, String yTitle, List<String> months) {
  return SizedBox(
    height: MediaQuery.of(context).size.width * 0.7,
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        groupsSpace: 12,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem('₹${yList[group.x.toInt()]}', TextStyle(color: Colors.white));
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
                  width: 25,
                  color: Colors.blue,
                ),
              ],
            ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            axisNameWidget: Text(yTitle),
            sideTitles: SideTitles(showTitles: true, reservedSize: 30),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: Text(xTitle),
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(months[value.toInt()].substring(0, 3)),
                );
              },
              reservedSize: 30,
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    ),
  );
}
