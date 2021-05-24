import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthForumService {
  String uid = FirebaseAuth.instance.currentUser.uid;
  final dbRef = FirebaseFirestore.instance.collection("Users");

  Future removeDiscussion(String id) async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .delete();
    return true;
  }
}