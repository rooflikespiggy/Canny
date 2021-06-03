import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/forum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ForumDatabaseService {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final CollectionReference forumCollection = Database().forumDatabase();

  Future addDiscussion(Forum forum) async {
    await forumCollection.add(forum.toMap());
    return true;
  }

  Future<List<Forum>> getComments() async {
    List<DocumentSnapshot> snapshots = await forumCollection
        .get()
        .then((value) => value.docs);
    return snapshots.map((doc) => Forum.fromMap(doc)).toList();
  }

  Future removeDiscussion(String forumId) async {
    await forumCollection
        .doc(forumId)
        .delete();
    return true;
  }

  Future updateDiscussion(String forumId,
      String newName,
      String newTitle,
      String newDescription) async {
    await forumCollection.doc(forumId).update({
      "name": newName,
      "title": newTitle,
      "description": newDescription,
      "timestamp": DateTime.now(),
    });
    return true;
  }

  Future updateLikes(List liked_uid,
      String forumId) async {
    if (liked_uid.contains(uid)) {
      await forumCollection.doc(forumId)
          .update({
        "likes": FieldValue.increment(-1),
        "liked_uid": FieldValue.arrayRemove([uid]),
      }).catchError((error) => print(error));
    } else {
      await forumCollection.doc(forumId)
          .update({
        "likes": FieldValue.increment(1),
        "liked_uid": FieldValue.arrayUnion([uid]),
      }).catchError((error) => print(error));
    }
  }
}