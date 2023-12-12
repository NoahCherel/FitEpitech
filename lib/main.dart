import 'dart:async';

import 'package:fitness_app/Profile/profileSetup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sensors/sensors.dart';

import 'Profile/profile.dart';
import 'auth.dart';
import 'firebase_options.dart';
import './UI/login.dart';
import './UI/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: WelcomeScreen.routeName,
      routes: {
        WelcomeScreen.routeName: (context) => WelcomeScreen(),
        AuthScreen.routeName: (context) => AuthScreen(),
        MainScreen.routeName: (context) => const MainScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        ProfileSetupScreen.routeName: (context) => ProfileSetupScreen(),
      },
    );
  }
}

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
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, ProfileScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await Auth().signOut();
              Navigator.pushReplacementNamed(context, AuthScreen.routeName);
            },
          ),
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
    );
  }
}
