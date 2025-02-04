import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 10),
                FlSpot(1, 30),
                FlSpot(2, 50),
                FlSpot(3, 70),
                FlSpot(4, 90),
                FlSpot(5, 100),
                FlSpot(6, 80),
              ],
              isCurved: true,
              color:Colors.blue,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}