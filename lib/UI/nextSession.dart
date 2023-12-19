import 'package:flutter/material.dart';

class NextSessionWidget extends StatelessWidget {
  final String workoutType;
  final DateTime dateTime;

  String formatDateTime(DateTime dateTime) {
    // Format the date
    String formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';

    // Format the time
    String amPm = dateTime.hour < 12 ? 'AM' : 'PM';
    int hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    String formattedTime = '$hour:${dateTime.minute.toString().padLeft(2, '0')} $amPm';

    // Combine date and time
    String formattedDateTime = '$formattedDate $formattedTime';

    return formattedDateTime;
  }

  NextSessionWidget({required this.workoutType, required this.dateTime});

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
            'Next Session:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Workout Type: $workoutType',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'When:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
            Text('${formatDateTime(dateTime)}',
              style: TextStyle(fontSize: 12),
            ),
        ],
      ),
    );
  }
}