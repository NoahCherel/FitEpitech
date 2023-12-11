// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC9Q9YnMMm_Mw1OhOFY0DGP9GbTpytkovw',
    appId: '1:742295731622:web:0683abdbedbf8d31246367',
    messagingSenderId: '742295731622',
    projectId: 'fittech-370cd',
    authDomain: 'fittech-370cd.firebaseapp.com',
    storageBucket: 'fittech-370cd.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkyngpn2tjrgXHylESJ87ImxvhlGedw3A',
    appId: '1:742295731622:android:f9029eb23a61d10f246367',
    messagingSenderId: '742295731622',
    projectId: 'fittech-370cd',
    storageBucket: 'fittech-370cd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBm-tctsNQMVN1cAQkXu4Cub4WGGLr7c5M',
    appId: '1:742295731622:ios:b42e7f8980c6560b246367',
    messagingSenderId: '742295731622',
    projectId: 'fittech-370cd',
    storageBucket: 'fittech-370cd.appspot.com',
    iosBundleId: 'com.example.fitnessApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBm-tctsNQMVN1cAQkXu4Cub4WGGLr7c5M',
    appId: '1:742295731622:ios:8e6ab56976a61f4a246367',
    messagingSenderId: '742295731622',
    projectId: 'fittech-370cd',
    storageBucket: 'fittech-370cd.appspot.com',
    iosBundleId: 'com.example.fitnessApp.RunnerTests',
  );
}
