import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCxtJtEyFkYdc_BLiqCse2ATt8CH8cPeyU',
    appId: '1:764436203864:web:48b603b67b038333b6fd2d',
    messagingSenderId: '764436203864',
    projectId: 'smart-expense-tracker-7d790',
    authDomain: 'smart-expense-tracker-7d790.firebaseapp.com',
    storageBucket: 'smart-expense-tracker-7d790.firebasestorage.app',
    measurementId: 'G-WGGSZSN8QT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCxtJtEyFkYdc_BLiqCse2ATt8CH8cPeyU',
    appId: '1:764436203864:android:3bfddc15697ab733b6fd2d',
    messagingSenderId: '764436203864',
    projectId: 'smart-expense-tracker-7d790',
    storageBucket: 'smart-expense-tracker-7d790.firebasestorage.app',
  );
}
