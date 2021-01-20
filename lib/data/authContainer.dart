import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/notifications/pushNotifications.dart';
import 'dart:developer';

import 'package:instiapp/themeing/notifier.dart';

class AuthContainer {
  var user;
  bool initialized = false;
  bool authorized = false;
  bool isGuest = false;
  FirebaseApp app;
  final GoogleSignIn gSignIn = GoogleSignIn(
    hostedDomain: 'iitgn.ac.in',
    scopes: <String>[
      'email',
      //'https://www.googleapis.com/auth/classroom.courses.readonly',
      'https://www.googleapis.com/auth/calendar.events.readonly',
    ],
  );

  Future<bool> initialize() async {
    log("INITIALIZING", name: "AUTH");
    await getTheme();
    await Firebase.initializeApp().then((value) {
      app = value;
      user = FirebaseAuth.instance.currentUser;
      initialized = true;
      if (user == null ||
          user.displayName == null ||
          user.displayName.length == 0) {
        authorized = false;
      } else {
        authorized = true;
      }
      log("AUTHORIZATION = $authorized", name: "AUTH");
      if (kReleaseMode) {
        log("ENABLED CRASHLYTICS", name: "AUTH");
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      }
    });
    PushNotificationsManager pushNotifs = PushNotificationsManager();
    pushNotifs.init();
    return authorized;
  }

  Future login(asGuest, Function callback) async {
    if (asGuest) {
      user = null;
      isGuest = true;
      authorized = true;
      await FirebaseAuth.instance.signInAnonymously();
    } else {
      log("TRYING GOOGLE SIGN IN", name: "AUTH");
      await signInWithGoogle().then((value) {
        user = value;
        authorized = true;
        callback();
      });
    }
  }

  Future logoutUser() async {
    dataContainer.auth.user = null;
    await gSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await gSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    User user;
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      user = value.user;
    });
    return user;
  }
}
