import 'dart:async';
import 'package:fitness_app/Fitness/calendar.dart';
import 'package:fitness_app/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import '../auth.dart';
import '../UI/login.dart';
import '../UI/welcome.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int steps = 0;
  int caloriesBurned = 0;
  Duration duration = Duration();
  double milesWalked = 0.0;
  late DateTime startTime;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeSensors();
    startMetricsUpdateTimer();
  }

  void initializeSensors() {
    startTime = DateTime.now();
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (event.y > 10) {
        setState(() {
          steps++;
          updateMetrics();
        });
      }
    });
  }

  void startMetricsUpdateTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        updateMetrics();
      });
    });
  }

  void updateMetrics() {
    caloriesBurned = steps ~/ 20;
    duration = DateTime.now().difference(startTime);
    milesWalked = steps * 0.0005;
    milesWalked = double.parse(milesWalked.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FitTech Pro'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await Auth().signOut();
              Navigator.pushReplacementNamed(context, AuthScreen.routeName);
            },
          ),
          // Calendar Button
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to FitTech Pro!',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20),
            Text(
              'Steps taken:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$steps',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Calories burned:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$caloriesBurned',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              'Duration:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              'Miles walked:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$milesWalked',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Navigate to the selected page
          if (_selectedIndex == 0) {
            // Home page is already being displayed, no need to navigate
          } else if (_selectedIndex == 1) {
            Navigator.pushNamed(context, CalendarScreen.routeName);
          } else if (_selectedIndex == 2) {
            Navigator.pushNamed(context, ProfileScreen.routeName);
          }
        },

      ),
    );
  }
}
