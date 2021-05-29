import 'package:Canny/Models/forum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthForumService {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final dbRef = FirebaseFirestore.instance.collection("Forum");

  Future addDiscussion(Forum forum) async {
    await dbRef.add(forum.toMap());
    return true;
  }

  Future removeDiscussion(String id) async {
    dbRef
        .doc(id)
        .delete();
    return true;
  }

  Future updateDiscussion(String id,
      String newName,
      String newTitle,
      String newDescription) async {
    await dbRef.doc(id).update({
      "name": newName,
      "title": newTitle,
      "description": newDescription,
      "timestamp": DateTime.now(),
    });
    return true;
  }

  Future updateLikes(List liked_uid,
      String id) async {
    if (liked_uid.contains(uid)) {
      await dbRef.doc(id)
          .update({
        "likes": FieldValue.increment(-1),
        "liked_uid": FieldValue.arrayRemove([uid]),
      }).catchError((error) => print(error));
    } else {
      await dbRef.doc(id)
          .update({
        "likes": FieldValue.increment(1),
        "liked_uid": FieldValue.arrayUnion([uid]),
      }).catchError((error) => print(error));
    }
  }
}