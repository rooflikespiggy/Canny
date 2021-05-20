import 'package:Canny/Screens/Authentication/register.dart';
import 'package:Canny/Screens/Authentication/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignedIn = true;

  void toggleSignInStatus() {
    setState(() => showSignedIn = !showSignedIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignedIn) {
      return SignIn(toggleSignInStatus: toggleSignInStatus);
    } else {
      return Register(toggleSignInStatus: toggleSignInStatus);
    }
  }
}


