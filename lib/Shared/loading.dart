import 'package:Canny/Shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final String message;

  Loading({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kLightBlue,
      child: Center(
        child: SpinKitFadingFour(
          color: kDarkBlue,
          size: 50.0,
        ),
      ),
    );
  }
}