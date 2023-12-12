import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../UI/login.dart';
import '../auth.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = Auth().getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Profile'),
        ),
        actions: [
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
        child: Text(
          'Welcome ${user!.email}\n?',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
