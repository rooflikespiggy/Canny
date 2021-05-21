import 'package:firebase_auth/firebase_auth.dart';

class OwnUser {
  final User theUser;

  OwnUser({ this.theUser });

  @override
  String toString() {
    return "uid of the user is " + this.theUser.uid;
  }
}


