// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCD6NzXyBKHO75SEHcndIr3-J6W01rPBCs',
    appId: '1:490778219235:web:a59cbac327b46e2ea52bd6',
    messagingSenderId: '490778219235',
    projectId: 'squizzi-9212f',
    authDomain: 'squizzi-9212f.firebaseapp.com',
    storageBucket: 'squizzi-9212f.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5lRl4bz5EiHumfGQUrr27DjtiuUXFRIc',
    appId: '1:490778219235:android:c646f197791642d5a52bd6',
    messagingSenderId: '490778219235',
    projectId: 'squizzi-9212f',
    storageBucket: 'squizzi-9212f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDWvUWoV2YKotBB23Kb89SiDriUMR9V5sA',
    appId: '1:490778219235:ios:154b9da9dce3e4aea52bd6',
    messagingSenderId: '490778219235',
    projectId: 'squizzi-9212f',
    storageBucket: 'squizzi-9212f.firebasestorage.app',
    iosBundleId: 'com.example.tp3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDWvUWoV2YKotBB23Kb89SiDriUMR9V5sA',
    appId: '1:490778219235:ios:154b9da9dce3e4aea52bd6',
    messagingSenderId: '490778219235',
    projectId: 'squizzi-9212f',
    storageBucket: 'squizzi-9212f.firebasestorage.app',
    iosBundleId: 'com.example.tp3',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCD6NzXyBKHO75SEHcndIr3-J6W01rPBCs',
    appId: '1:490778219235:web:2d506930666487c8a52bd6',
    messagingSenderId: '490778219235',
    projectId: 'squizzi-9212f',
    authDomain: 'squizzi-9212f.firebaseapp.com',
    storageBucket: 'squizzi-9212f.firebasestorage.app',
  );

}