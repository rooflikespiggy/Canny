import 'package:Canny/Shared/splash.dart';
import 'package:after_layout/after_layout.dart';
import 'package:Canny/Screens/wrapper.dart';
import 'package:Canny/Services/Users/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  static final String id = 'splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {

  @override
  void afterFirstLayout(BuildContext context) async {
    Future.delayed(Duration(seconds: 1), _checkIfUserIsLoggedIn);
  }

  _checkIfUserIsLoggedIn() async {
    AuthService _auth = AuthService();

    try {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Wrapper()));
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(40),
                child: Text(e.message),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Splash();
  }
}