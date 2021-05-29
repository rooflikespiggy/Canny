import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Canny/Models/comment.dart';


class AuthCommentService {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final String inputId;
  final dbCommentRef = FirebaseFirestore.instance.collection("ForumComment");
  final dbRef = FirebaseFirestore.instance.collection("Forum");

  AuthCommentService(this.inputId);


  Future addComment(Comment comment) async {
    await dbCommentRef.doc(inputId)
        .collection("Comment")
        .add(comment.toMap());
    return true;
  }

  Future removeComment(String commentId) async {
    await dbCommentRef
        .doc(inputId)
        .collection("Comment")
        .doc(commentId)
        .delete();
    await dbRef
        .doc(inputId)
        .update({
      "comments": FieldValue.increment(-1),
    });
    return true;
  }

  Future updateComment(String commentId,
      String newName,
      String newDescription) async {
    await dbCommentRef.doc(inputId)
        .collection("Comment")
        .doc(commentId)
        .update({
      "name": newName,
      "description": newDescription,
      "timestamp": DateTime.now(),
    });
    await dbRef.doc(inputId).update({
      "comments": FieldValue.increment(1),
    });
    return true;
  }

  Future updateLikes(List liked_uid,
      List disliked_uid,
      String commentId) async {
    if (liked_uid.contains(uid)) {
      await dbCommentRef
          .doc(inputId)
          .collection("Comment")
          .doc(commentId)
          .update({
        "likes": FieldValue.increment(-1),
        "liked_uid": FieldValue.arrayRemove([uid]),
      }).catchError((error) => print(error));
    } else if (disliked_uid.contains(uid)) {
      await dbCommentRef
          .doc(inputId)
          .collection("Comment")
          .doc(commentId)
          .update({
        "likes": FieldValue.increment(1),
        "dislikes": FieldValue.increment(-1),
        "liked_uid": FieldValue.arrayUnion([uid]),
        "disliked_uid": FieldValue.arrayRemove([uid]),
      }).catchError((error) => print(error));
    } else {
      await dbCommentRef
          .doc(inputId)
          .collection("Comment")
          .doc(commentId)
          .update({
        "likes": FieldValue.increment(1),
        "liked_uid": FieldValue.arrayUnion([uid]),
      }).catchError((error) => print(error));
    }
    return true;
  }

  Future updateDislikes(List liked_uid,
      List disliked_uid,
      String commentId) async {
    if (disliked_uid.contains(uid)) {
      await dbCommentRef
          .doc(inputId)
          .collection("Comment")
          .doc(commentId)
          .update({
        "dislikes": FieldValue.increment(-1),
        "disliked_uid": FieldValue.arrayRemove([uid]),
      }).catchError((error) => print(error));
    } else if (liked_uid.contains(uid)) {
      await dbCommentRef
          .doc(inputId)
          .collection("Comment")
          .doc(commentId)
          .update({
        "likes": FieldValue.increment(-1),
        "dislikes": FieldValue.increment(1),
        "liked_uid": FieldValue.arrayRemove([uid]),
        "disliked_uid": FieldValue.arrayUnion([uid]),
      }).catchError((error) => print(error));
    } else {
      await dbCommentRef
          .doc(inputId)
          .collection("Comment")
          .doc(commentId)
          .update({
        "dislikes": FieldValue.increment(1),
        "disliked_uid": FieldValue.arrayUnion([uid]),
      }).catchError((error) => print(error));
    }
    return true;
  }
}