import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
  final CollectionReference forumCollection = FirebaseFirestore.instance.collection('Forum');
  final CollectionReference forumCommentCollection = FirebaseFirestore.instance.collection('ForumComment');
  final String uid = FirebaseAuth.instance.currentUser.uid;


  CollectionReference forumDatabase() {
    return forumCollection;
  }

  CollectionReference forumCommentDatabase() {
    return forumCommentCollection;
  }

  CollectionReference categoryDatabase() {
    return userCollection
        .doc(uid)
        .collection('Category');
  }

  CollectionReference expensesDatabase() {
    return userCollection
        .doc(uid)
        .collection('Receipt');
  }

  CollectionReference quickInputDatabase() {
    return userCollection
        .doc(uid)
        .collection('QuickInput');
  }
}