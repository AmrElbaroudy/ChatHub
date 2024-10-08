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
    apiKey: 'AIzaSyD5cY579tJRPMjXRvA7wvfILpndpNRHN6Q',
    appId: '1:522513257059:web:4d3842f03a6feb39925e56',
    messagingSenderId: '522513257059',
    projectId: 'chathub-94c90',
    authDomain: 'chathub-94c90.firebaseapp.com',
    storageBucket: 'chathub-94c90.appspot.com',
    measurementId: 'G-97JE7SWDCK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCeCBYAtp2QREX0MsyocxNOis5kGjeBhiA',
    appId: '1:522513257059:android:5ecacd57ffa49a02925e56',
    messagingSenderId: '522513257059',
    projectId: 'chathub-94c90',
    storageBucket: 'chathub-94c90.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8hC3AMrgidMljavTYtGq8PfQ438yonSE',
    appId: '1:522513257059:ios:43991e1371f12e53925e56',
    messagingSenderId: '522513257059',
    projectId: 'chathub-94c90',
    storageBucket: 'chathub-94c90.appspot.com',
    iosBundleId: 'com.elbaroudy.chathub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC8hC3AMrgidMljavTYtGq8PfQ438yonSE',
    appId: '1:522513257059:ios:5c6491e88b587406925e56',
    messagingSenderId: '522513257059',
    projectId: 'chathub-94c90',
    storageBucket: 'chathub-94c90.appspot.com',
    iosBundleId: 'com.example.chatHub',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD5cY579tJRPMjXRvA7wvfILpndpNRHN6Q',
    appId: '1:522513257059:web:cc52f45b70efc309925e56',
    messagingSenderId: '522513257059',
    projectId: 'chathub-94c90',
    authDomain: 'chathub-94c90.firebaseapp.com',
    storageBucket: 'chathub-94c90.appspot.com',
    measurementId: 'G-8GW3PRDFPY',
  );
}
