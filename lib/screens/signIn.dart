import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  void authorize(asGuest ){
    if(asGuest){
    }
    else{

    }
    Navigator.pop(context);
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/homepageGif.gif'),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text("All things IITGN",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),
              ),
              SizedBox(height: 100),
              FlatButton(
                onPressed: () => authorize(false),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(40.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Text(
                      "Login with IITGN ID(Google)",
                      style: TextStyle(
                        color: Colors.white.withAlpha(230),
                      ),
                    ),
                  ),
                ),
                color: Color.fromRGBO(228, 110, 96, 1),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                child: Text(
                  "or",
                  style: TextStyle(
                    color: Colors.grey.withAlpha(230),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () => authorize(true),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(40.0),
                  side: BorderSide(color: Colors.grey.withAlpha(50),)
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 16),
                  child: Container(
                    child: Text(
                      "Login as Guest",
                      style: TextStyle(
                        color: Colors.grey.withAlpha(230),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
