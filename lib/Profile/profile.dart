import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/Profile/profileSetup.dart';
import 'package:flutter/material.dart';
import '../UI/login.dart';
import '../auth.dart';
import '../addData.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> handleSignOut(BuildContext context) async {
    try {
      await Auth().signOut();
      Navigator.pushReplacementNamed(context, AuthScreen.routeName);
    } catch (error) {
      print(error);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Center(child: Text('Profile', style: TextStyle(fontSize: 24.0, color: Colors.black))),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, ProfileSetupScreen.routeName);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: AddData().getProfileData(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;

            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display Profile Information Row
                  Row(
                    children: [
                      // Display Profile Picture
                      // Put the image and the name in a Container to make it easier to add border

                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage('${data['image']}'),
                      ),

                      // Display Name
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            '${data['name']}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Put some space between profile information and other information
                  SizedBox(height: 20.0),

                  // Display other information in a row with equal size
                  Row(
                    children: [
                      // Display Age
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.only(right: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${data['age']}yo',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                'Age',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Display Height
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${data['height']}cm',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                'Height',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Display Weight
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${data['weight']}kg',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                'Weight',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
