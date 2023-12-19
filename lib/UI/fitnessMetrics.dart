import 'package:flutter/material.dart';

class SmallFitnessMetricsWidget extends StatefulWidget {
  final int steps;
  final int caloriesBurned;
  final Duration duration;
  final double milesWalked;

  const SmallFitnessMetricsWidget({
    required this.steps,
    required this.caloriesBurned,
    required this.duration,
    required this.milesWalked,
    Key? key,
  }) : super(key: key);

  @override
  _SmallFitnessMetricsWidgetState createState() => _SmallFitnessMetricsWidgetState();
}

class _SmallFitnessMetricsWidgetState extends State<SmallFitnessMetricsWidget> {
  bool isStarted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 2.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0),
      child: isStarted
          ? _buildMetricsGrid()
          : _buildStartButton(),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2, // Number of columns in the grid
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      children: <Widget>[
        _buildMetricItem('Steps', '${widget.steps}'),
        _buildMetricItem('Calories', '${widget.caloriesBurned}'),
        _buildMetricItem('Duration', '${widget.duration.inMinutes} min'),
        _buildMetricItem('Miles', '${widget.milesWalked}'),
      ],
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isStarted = true;
          });
        },
        child: Text('Start'),
      ),
    );
  }
}
