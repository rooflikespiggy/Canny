import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthForumService {
  String uid = FirebaseAuth.instance.currentUser.uid;
  final dbRef = FirebaseFirestore.instance.collection("Users");

  Future removeDiscussion(String title) async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Title')
        .doc(title)
        .delete();
    return true;
  }
}