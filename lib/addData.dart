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
