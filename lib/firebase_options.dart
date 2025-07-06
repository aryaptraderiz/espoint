import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

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
    apiKey: "AIzaSyDxKuY4nFkOwRKm8jIY0Sir5zl64lwEmlQ",
    authDomain: "espointflutter.firebaseapp.com",
    projectId: "espointflutter",
    storageBucket: "espointflutter.firebasestorage.app",
    messagingSenderId: "1051820998552",
    appId: "1:1051820998552:web:3b3a4180b5b857fe81b5ed",
    measurementId: "G-KE04CZWWGE",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDxKuY4nFkOwRKm8jIY0Sir5zl64lwEmlQ",
    authDomain: "espointflutter.firebaseapp.com",
    projectId: "espointflutter",
    storageBucket: "espointflutter.firebasestorage.app",
    messagingSenderId: "1051820998552",
    appId: "1:1051820998552:web:3b3a4180b5b857fe81b5ed",
    measurementId: "G-KE04CZWWGE",
  );
}