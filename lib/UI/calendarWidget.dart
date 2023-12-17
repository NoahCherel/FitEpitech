import 'package:flutter/material.dart';

class SmallCalendarWidget extends StatelessWidget {
  final DateTime selectedDay;
  final List<String> events;

  const SmallCalendarWidget({
    required this.selectedDay,
    required this.events,
    Key? key,
  }) : super(key: key);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Day:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Events:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          for (String event in events)
            Text(
              '- $event',
              style: TextStyle(fontSize: 16),
            ),
        ],
      ),
    );
  }
}
