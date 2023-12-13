import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUserData(String uid, String username, String email, String height, String weight, String age) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'username': username,
    'email': email,
    'height': height,
    'weight': weight,
    'age': age,
  });
}

// Get user data
Future<DocumentSnapshot> getUserData(String uid) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return documentSnapshot;
}

// Update user data
Future<void> updateUserData(String uid, String username, String email, String height, String weight, String age) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'username': username,
    'email': email,
    'height': height,
    'weight': weight,
    'age': age,
  });
}

