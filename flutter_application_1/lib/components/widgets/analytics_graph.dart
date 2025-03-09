import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomGraph extends StatelessWidget {
  final List<double> xList;
  final List<double> yList;
  final String xTitle;
  final String yTitle;

  const CustomGraph({
    Key? key,
    required this.xList,
    required this.yList,
    required this.xTitle,
    required this.yTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5, // Adjust aspect ratio
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false), // Hide background grid
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(value.toString(), style: const TextStyle(fontSize: 12));
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(value.toString(), style: const TextStyle(fontSize: 12));
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true), // Show chart border
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  xList.length,
                      (index) => FlSpot(xList[index], yList[index]),
                ),
                isCurved: true, // Smooth curve
                color: Colors.blue,
                barWidth: 3,
                belowBarData: BarAreaData(show: false), // No fill color
                dotData: FlDotData(show: true), // Show points
              ),
            ],
          ),
        ),
      ),
    );
  }
}
