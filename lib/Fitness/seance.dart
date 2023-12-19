import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GymSession {
  DateTime dateTime;
  String workoutType;
  String location;

  GymSession({
    required this.dateTime,
    required this.workoutType,
    required this.location,
  });
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserData(String uid, UserData userData) async {
    await _firestore.collection('users').doc(uid).set({
      'username': userData.username,
      'email': userData.email,
      'height': userData.height,
      'weight': userData.weight,
      'age': userData.age,
    });
  }

  Future<UserData> getUserData(String uid) async {
    DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(uid).get();
    Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

    return UserData(
      username: data?['username'] ?? '',
      email: data?['email'] ?? '',
      height: data?['height'] ?? '',
      weight: data?['weight'] ?? '',
      age: data?['age'] ?? '',
    );
  }

  Future<void> updateUserData(String uid, UserData userData) async {
    await _firestore.collection('users').doc(uid).update({
      'username': userData.username,
      'email': userData.email,
      'height': userData.height,
      'weight': userData.weight,
      'age': userData.age,
    });
  }

  Future<void> saveSession(String uid, GymSession session) async {
    await _firestore.collection('users').doc(uid).collection('sessions').add({
      'dateTime': session.dateTime,
      'workoutType': session.workoutType,
      'location': session.location,
    });
  }

  Future<void> savePastSession(String uid, GymSession session) async {
    await _firestore.collection('users').doc(uid).collection('past_sessions').add({
      'dateTime': session.dateTime,
      'workoutType': session.workoutType,
      'location': session.location,
    });
  }

  Future<List<GymSession>> getSessions(String uid) async {
    QuerySnapshot sessionSnapshot =
    await _firestore.collection('users').doc(uid).collection('sessions').get();

    List<GymSession> sessions = [];
    sessionSnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      sessions.add(GymSession(
        dateTime: (data['dateTime'] as Timestamp).toDate(),
        workoutType: data['workoutType'],
        location: data['location'],
      ));
    });

    return sessions;
  }

  Future<List<GymSession>> getPastSessions(String uid) async {
    QuerySnapshot sessionSnapshot =
    await _firestore.collection('users').doc(uid).collection('past_sessions').get();

    List<GymSession> sessions = [];
    sessionSnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      sessions.add(GymSession(
        dateTime: (data['dateTime'] as Timestamp).toDate(),
        workoutType: data['workoutType'],
        location: data['location'],
      ));
    });

    return sessions;
  }

  Future<GymSession?> getNextSession(String uid) async {
    QuerySnapshot sessionSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .orderBy('dateTime')
        .limit(1)
        .get();

    if (sessionSnapshot.docs.length > 0) {
      DocumentSnapshot sessionDoc = sessionSnapshot.docs[0];
      Map<String, dynamic> data = sessionDoc.data() as Map<String, dynamic>;
      return GymSession(
        dateTime: (data['dateTime'] as Timestamp).toDate(),
        workoutType: data['workoutType'],
        location: data['location'],
      );
    } else {
      return null;
    }
  }

  Future<void> removeLastSession(String uid) async {
    QuerySnapshot sessionSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .orderBy('dateTime')
        .limit(1)
        .get();

    if (sessionSnapshot.docs.length > 0) {
      DocumentSnapshot sessionDoc = sessionSnapshot.docs[0];

      // Get the data from the session
      Map<String, dynamic> sessionData = sessionDoc.data() as Map<String, dynamic>;

      // Save the session to 'past_sessions'
      await savePastSession(uid, GymSession(
        dateTime: (sessionData['dateTime'] as Timestamp).toDate(),
        workoutType: sessionData['workoutType'],
        location: sessionData['location'],
      ));

      // Delete the session from the 'sessions' collection
      await sessionDoc.reference.delete();
    }
  }
}

class UserData {
  String username;
  String email;
  String height;
  String weight;
  String age;

  UserData({
    required this.username,
    required this.email,
    required this.height,
    required this.weight,
    required this.age,
  });
}

class ScheduleSessionScreen extends StatefulWidget {
  static const routeName = '/schedule-session';
  @override
  _ScheduleSessionScreenState createState() => _ScheduleSessionScreenState();
}

class _ScheduleSessionScreenState extends State<ScheduleSessionScreen> {
  DateTime selectedDateTime = DateTime.now();
  String workoutType = '';
  String location = '';

  void _scheduleSession() async {
    GymSession newSession = GymSession(dateTime: selectedDateTime, workoutType: workoutType, location: location);

    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      // Save the session to Firestore
      FirestoreService().saveSession(uid, newSession);

      // Optionally, navigate back to the main screen or update the UI
      Navigator.pop(context);
    } else {
      // Handle the case where the user is not logged in
      print('User is not logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Gym Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Select Date and Time:'),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDateTime = await showDatePicker(
                  context: context,
                  initialDate: selectedDateTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );

                if (pickedDateTime != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                  );

                  if (pickedTime != null) {
                    setState(() {
                      selectedDateTime = DateTime(
                        pickedDateTime.year,
                        pickedDateTime.month,
                        pickedDateTime.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                }
              },
              child: Text('Pick Date and Time'),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(labelText: 'Workout Type'),
              onChanged: (value) {
                setState(() {
                  workoutType = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(labelText: 'Location'),
              onChanged: (value) {
                setState(() {
                  location = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _scheduleSession,
              child: Text('Schedule Session'),
            ),
          ],
        ),
      ),
    );
  }
}

class SessionScreen extends StatefulWidget {
  static const routeName = '/session';
  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  List<GymSession> sessions = [];

  @override
  void initState() {
    super.initState();
    // Get sessions when the screen is initialized
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      // Load upcoming sessions for the user
      List<GymSession> upcomingSessions = await FirestoreService().getSessions(uid);

      // Load past sessions for the user
      List<GymSession> pastSessions = await FirestoreService().getPastSessions(uid);

      setState(() {
        sessions = [...upcomingSessions, ...pastSessions];
      });
    } else {
      // Handle the case where the user is not logged in
      print('User is not logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduled Gym Sessions'),
      ),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          GymSession session = sessions[index];
          return ListTile(
            title: Text('Workout Type: ${session.workoutType}'),
            subtitle: Text('Location: ${session.location}'),
            trailing: Text('Date and Time: ${session.dateTime.toString()}'),
          );
        },
      ),
    );
  }
}

class PastSessionsScreen extends StatelessWidget {
  static const routeName = '/past-sessions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Gym Sessions'),
      ),
      body: FutureBuilder<List<GymSession>>(
        future: FirestoreService().getPastSessions(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<GymSession> pastSessions = snapshot.data ?? [];

            return ListView.builder(
              itemCount: pastSessions.length,
              itemBuilder: (context, index) {
                GymSession session = pastSessions[index];
                return ListTile(
                  title: Text('Workout Type: ${session.workoutType}'),
                  subtitle: Text('Location: ${session.location}'),
                  trailing: Text('Date and Time: ${session.dateTime.toString()}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
