import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Graphs",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      // x-axis labels (months)
                      switch (value.toInt()) {
                        case 0:
                          return const Text("Jan");
                        case 1:
                          return const Text("Feb");
                        case 2:
                          return const Text("Mar");
                        case 3:
                          return const Text("Apr");
                        case 4:
                          return const Text("May");
                        case 5:
                          return const Text("Jun");
                      }
                      return const Text("");
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text("${value.toInt()}");
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: Colors.deepOrange,
                  barWidth: 3,
                  spots: [
                    FlSpot(0, 2),
                    FlSpot(1, 4),
                    FlSpot(2, 3),
                    FlSpot(3, 5),
                    FlSpot(4, 8),
                    FlSpot(5, 6),
                  ],
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
