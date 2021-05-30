import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
  final String uid = FirebaseAuth.instance.currentUser.uid;


  CollectionReference forumDatabase() {
    return userCollection
        .doc(uid)
        .collection('Forum');
  }

  CollectionReference forumCommentDatabase() {
    return userCollection
        .doc(uid)
        .collection('ForumComment');
  }

  CollectionReference categoryDatabase() {
    return userCollection
        .doc(uid)
        .collection('Category');
  }
}