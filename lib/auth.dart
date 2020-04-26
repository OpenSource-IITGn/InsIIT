import 'package:google_sign_in/google_sign_in/dart';
import 'package:flutter/material.dart';


final GoogleSignIn gSignIn = GoogleSignIn() ;


class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  bool isSignedIn = false ;


  void initState(){
    super.initState();

    gSignIn.onCurrentUserchanged.listen((gSigninAccount){
      controlSignIn(gSigninAccount);
    },onError: (gError) {
      print("Error message :" + gError) ;
    
    });

  gSignIn.signInSilently(supressErrors : false).then((gSignInAccount){
    controlSignIn(gSignInAccount);
  }).catchError((gError){
    print("Error message :" + gError) ;
  }

  controlSignIn(GoogleSignInAccount signInAccount)async{
    if(signInAccount != null) {
      setState(() {
        isSignedIn = true ;
      });
    }
    else{
      setState(() {
        isSignedIn = false ;
      });
    }

  }

  loginUser(){
    gSignIn.signIn(); 
  }

  logoutUser(){
    gSignIn.signOut();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}


