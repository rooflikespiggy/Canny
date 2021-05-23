import 'package:Canny/Models/own_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

/*
  //sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User theUser = result.user;
      return _userFromFirebaseUser(theUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
 */

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