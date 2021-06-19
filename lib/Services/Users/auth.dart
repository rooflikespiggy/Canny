import 'package:Canny/Models/own_user.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Services/Dashboard/dashboard_database.dart';
import 'package:Canny/Services/Quick%20Input/quickinput_database.dart';
import 'package:Canny/Services/Targeted%20Expenditure/TE_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Canny/Services/Notification/notification_database.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  OwnUser _userFromFirebaseUser(User theUser) {
    return theUser != null ? OwnUser(theUser: theUser) : null;
  }

  //auth change user stream
  Stream<OwnUser> get userFromStream {
    return _auth.authStateChanges()
        .map((User theUser) => _userFromFirebaseUser(theUser));
  }


  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User theUser = result.user;
      return _userFromFirebaseUser(theUser);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User theUser = result.user;
      await CategoryDatabaseService(uid: theUser.uid).initStartCategories();
      await QuickInputDatabaseService(uid: theUser.uid).initStartQuickInputs();
      await TEDatabaseService(uid: theUser.uid).initStartTE();
      await DashboardDatabaseService(uid: theUser.uid).initStartSwitch();
      await NotificationDatabaseService(uid: theUser.uid).initStartNotif();
      //await TEDatabaseService(uid: theUser.uid).addTargetedExpenditure();
      return _userFromFirebaseUser(theUser);
    } catch (e) {
      print(e.toString());
      return "email-in-use";
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}