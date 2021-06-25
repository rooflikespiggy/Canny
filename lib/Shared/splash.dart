import 'package:Canny/Shared/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kLightBlue,
        child: Center(
          child: Container(
            width: 400.0,
            height: 400.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('styles/images/logo-9.png'),
                  fit: BoxFit.fill
              ),
            ),
          ),
        ),
      ),
    );
  }
}