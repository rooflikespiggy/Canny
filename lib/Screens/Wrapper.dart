import 'package:Canny/Models/own_user.dart';
import 'package:Canny/Screens/Authentication/authenticate.dart';
import 'package:Canny/Screens/Home/function_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final theUser = Provider.of<OwnUser>(context);

    //return home or authenticate depending on whether the user is signed in or not
    if (theUser == null) {
      return Authenticate();
    } else {
      return FunctionScreen();
    }
  }
}
