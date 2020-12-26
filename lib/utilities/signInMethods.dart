import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/data/dataContainer.dart';

logoutUser() async {
  dataContainer.fireBase.user = null;
  await gSignIn.signOut();
  await FirebaseAuth.instance.signOut();
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount googleUser =
      await gSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
