import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  final List<double> data;
  final List<String> labels;

  ChartWidget({required this.data, required this.labels});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LineChart(
            LineChartData(

              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: const Color(0xff37434d), width: 1),
              ),
              minX: 0,
              maxX: 6,
              minY: 0,
              maxY: data.reduce((value, element) => value > element ? value : element) + 100,
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(7, (index) => FlSpot(index.toDouble(), data[index])),
                  isCurved: true,
                  color: Colors.black,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.blueAccent,
                ),
                handleBuiltInTouches: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chart Widget Example'),
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10.0),
              child: ChartWidget(
                data: [100, 150, 200, 180, 220, 250, 170], // Replace with your actual data
                labels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
