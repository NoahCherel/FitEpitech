import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/Fitness/calendar.dart';
import 'package:fitness_app/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import '../auth.dart';
import '../UI/login.dart';
import '../UI/welcome.dart';
import 'fitnessMetrics.dart';
import 'calendarWidget.dart';
import '../UI/chart.dart';
import '../Fitness/seance.dart';
import 'nextSession.dart';

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
  // Sample data for the graph
  List<double> weeklyCalories = [150.0, 200.0, 180.0, 250.0, 220.0, 190.0, 200.0];

  @override
  void initState() {
    super.initState();
    initializeSensors();
    startMetricsUpdateTimer();
    loadNextSession();
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

  Widget? _nextSession;

  Widget? removePassedSession(DateTime dateTime, Widget sessionWidget) {
    DateTime now = DateTime.now();

    // Check if the session time has passed
    if (dateTime.isBefore(now)) {
      return null; // Return null to indicate that the session should be removed
    } else {
      return sessionWidget; // Return the session widget if the time hasn't passed
    }
  }

  void loadNextSession() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      GymSession? nextSession = await FirestoreService().getNextSession(uid);

      if (nextSession != null) {
        // Use the removePassedSession function to check if the session time has passed
        Widget? sessionWidget = removePassedSession(nextSession.dateTime, NextSessionWidget(
          workoutType: nextSession.workoutType,
          dateTime: nextSession.dateTime,
        ));

        if (sessionWidget != null) {
          setState(() {
            _nextSession = sessionWidget;
          });
        } else {
          // The session time has passed, do something (e.g., remove it from Firestore)
          FirestoreService().removeLastSession(uid);
        }
      }
    }
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
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
                  child: _nextSession,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ChartWidget(
                data: weeklyCalories,
                labels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, SessionScreen.routeName);
                },
                child: Text('See scheduled workouts'),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ScheduleSessionScreen.routeName);
                },
                child: Text('Schedule a workout'),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, PastSessionsScreen.routeName);
                },
                child: Text('See past sessions'),
              ),
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
