import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

logoutUser() async {
  await GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount googleUser =
      await GoogleSignIn(hostedDomain: 'iitgn.ac.in').signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
