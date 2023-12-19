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
import './Fitness/calendar.dart';
import './UI/homepage.dart';
import './Fitness/seance.dart';

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
        CalendarScreen.routeName: (context) => const CalendarScreen(),
        SessionScreen.routeName: (context) => SessionScreen(),
        ScheduleSessionScreen.routeName: (context) => ScheduleSessionScreen(),
        PastSessionsScreen.routeName: (context) => PastSessionsScreen(),
      },
    );
  }
}
