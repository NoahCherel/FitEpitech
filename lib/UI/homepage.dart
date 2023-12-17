import 'dart:async';
import 'package:fitness_app/Fitness/calendar.dart';
import 'package:fitness_app/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import '../auth.dart';
import '../UI/login.dart';
import '../UI/welcome.dart';
import 'fitnessMetrics.dart';
import 'calendarWidget.dart';

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
  List<Event> _events = [];

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Use a GridView for the grid layout
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1, // Adjust this aspect ratio to change the box size
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: SmallFitnessMetricsWidget(
                    steps: steps,
                    caloriesBurned: caloriesBurned,
                    duration: duration,
                    milesWalked: milesWalked,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: SmallCalendarWidget(
                    selectedDay: DateTime.now(),
                    events: _events.map((event) => event.workoutActivity).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
