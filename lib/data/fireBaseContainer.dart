import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseContainer {
  var user;
  bool initialized = false;
  bool gotUser = false;
  FirebaseApp app;

  initialize (Function f) {
    Firebase.initializeApp().then((value) {
      app = value;
      user = FirebaseAuth.instance.currentUser;
      initialized = true;
      gotUser = true;
      print('Initialized and get user');
      f();
    });
  }

  getUser () {
    user = FirebaseAuth.instance.currentUser;
    gotUser = true;
    print('Get user');
  }
}