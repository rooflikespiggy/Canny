import 'package:Canny/Screens/Forum/forum_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthCommentService {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final String inputId;
  final dbCommentRef = FirebaseFirestore.instance.collection("ForumComment");
  final dbRef = FirebaseFirestore.instance.collection("Forum");

  AuthCommentService(this.inputId);

  Future addComment(TextEditingController nameController,
      TextEditingController descriptionController,
      BuildContext context,
      GlobalKey<FormState> _formKey) async {

    if (_formKey.currentState.validate()) {
      print(inputId);
      dbCommentRef
          .doc(inputId)
          .collection("Comment")
          .add({
        "uid": uid,
        "did": inputId,
        "name": nameController.text,
        "description": descriptionController.text,
        "timestamp": DateTime.now(),
        "likes": 0,
        "dislikes": 0,
        "liked_uid": [],
        "disliked_uid": [],
      }).then((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Succesfully Submitted Your Comment!",
                style: TextStyle(fontFamily: 'Lato'),
              ),
              content: Text(
                "If you would like to add any additional comments, press No",
                style: TextStyle(fontFamily: 'Lato.Thin'),
              ),
              actions: <Widget> [
                TextButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ForumDetailScreen(inputId: inputId)));
                  },
                ),
                TextButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        nameController.clear();
        descriptionController.clear();
      }).catchError((error) => print(error));
    }
    return true;
  }

  Future removeComment(String commentId) async {
    dbCommentRef
        .doc(inputId)
        .collection("Comment")
        .doc(commentId)
        .delete();
    dbRef.doc(inputId).update({
      "comments": FieldValue.increment(-1),
    });
    return true;
  }

  Future updateComment(TextEditingController nameInputController,
      TextEditingController descriptionInputController,
      BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot,
      int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          content: Column(
            children: <Widget> [
              Text("Update discussion"),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Edit Name"
                  ),
                  controller: nameInputController,
                ),
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: "Edit Description"
                  ),
                  controller: descriptionInputController,
                ),
              ),
            ],
          ),
          actions: <Widget> [
            TextButton(
                onPressed: () {
                  nameInputController.clear();
                  descriptionInputController.clear();
                  Navigator.pop(context);
                },
                child: Text("Cancel")
            ),
            TextButton(
                onPressed: () {
                  if (nameInputController.text.isNotEmpty &&
                      descriptionInputController.text.isNotEmpty) {
                    dbCommentRef
                        .doc(inputId)
                        .collection("Comment")
                        .doc(snapshot.data.docs[index].id).update({
                      "uid": uid,
                      "name": nameInputController.text,
                      "description": descriptionInputController.text,
                      "timestamp": DateTime.now(),
                    }).then((_) {
                      nameInputController.clear();
                      descriptionInputController.clear();
                      Navigator.pop(context);
                    }).catchError((error) => print(error));
                  }
                },
                child: Text("Update")
            ),
          ],
        );
      },
    );
    return true;
  }
}