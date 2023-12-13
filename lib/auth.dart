import 'package:firebase_auth/firebase_auth.dart';

class Auth {
    //Creating new instance of firebase auth
    final FirebaseAuth _auth = FirebaseAuth.instance;

    Future registerWithEmailAndPassword(String email, String password) async {
        try {
            // This will create a new user in our firebase
            await _auth.createUserWithEmailAndPassword(
                email: email,
                password: password,
            );
            return "Signed up";
        } on FirebaseAuthException catch (e) {
            return e.toString();
        } catch (e) {
            return e.toString();
        }
    }

    Future signInWithEmailAndPassword(String email, String password) async {
        try {
            // This will Log in the existing user in our firebase
            await _auth.signInWithEmailAndPassword(
                email: email,
                password: password,
            );
            return "Signed in";
        } on FirebaseAuthException catch (e) {
            return e.toString();
        } catch (e) {
            return e.toString();
        }
    }

    Future<void> signOut() async {
        await _auth.signOut();
    }
}