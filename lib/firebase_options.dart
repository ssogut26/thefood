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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBNnUNY_IbO6RiwQKRc8u6aKVWLyoRv1B4',
    appId: '1:651831056889:web:0a2d2893788b26d3d90528',
    messagingSenderId: '651831056889',
    projectId: 'thefood-6e177',
    authDomain: 'thefood-6e177.firebaseapp.com',
    storageBucket: 'thefood-6e177.appspot.com',
    measurementId: 'G-6YGXP4DENG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCc5RIH-RN02TMAP7dSXvnXfIgQxUN3lU',
    appId: '1:651831056889:android:1f8a511b0eb5ec51d90528',
    messagingSenderId: '651831056889',
    projectId: 'thefood-6e177',
    storageBucket: 'thefood-6e177.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBLYJ3hFHGE7vrQLxL8ELranwZC8upZVhE',
    appId: '1:651831056889:ios:455ff88f81536325d90528',
    messagingSenderId: '651831056889',
    projectId: 'thefood-6e177',
    storageBucket: 'thefood-6e177.appspot.com',
    iosClientId: '651831056889-2ocena3le54pnjf5dpvosd0tkebg3vs3.apps.googleusercontent.com',
    iosBundleId: 'com.example.thefood',
  );
}
