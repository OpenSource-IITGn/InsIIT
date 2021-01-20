import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      _firebaseMessaging.configure(onMessage: (msg) {
        log("RECEIVED MESSAGE ONMESSAGE $msg", name: 'FIREBASE');
        return;
      }, onLaunch: (msg) {
        log("RECEIVED MESSAGE ONLAUNCH $msg", name: 'FIREBASE');
        return;
      }, onResume: (msg) {
        log("RECEIVED MESSAGE ONRESUME $msg", name: 'FIREBASE');
        return;
      });
      log("FirebaseMessaging token: $token", name: 'FIREBASE');

      _initialized = true;
    }
  }
}
