import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthForumService {
  String uid = FirebaseAuth.instance.currentUser.uid;
  final dbRef = FirebaseFirestore.instance.collection("Forum");

  Future addDiscussion(TextEditingController nameController,
      TextEditingController titleController,
      TextEditingController descriptionController,
      BuildContext context,
      GlobalKey<FormState> _formKey) async {

    if (_formKey.currentState.validate()) {
      dbRef.add({
        "uid": uid,
        "name": nameController.text,
        "title": titleController.text,
        "description": descriptionController.text,
        "timestamp": DateTime.now(),
        "likes": 0,
        "liked": false,
        "comments": 0,
      }).then((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Succesfully Submitted Your Discussion!",
                style: TextStyle(fontFamily: 'Lato'),
              ),
              content: Text(
                "If you would like to add any additional discussions, press No",
                style: TextStyle(fontFamily: 'Lato.Thin'),
              ),
              actions: <Widget> [
                TextButton(
                  child: Text("Yes"),
                  onPressed: () {
                    int count = 0;
                    Navigator.popUntil(context, (route) {
                      return count++ == 2;
                    });
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
        titleController.clear();
        nameController.clear();
        descriptionController.clear();
      }).catchError((error) => print(error));
    }
    return true;
  }

  Future removeDiscussion(String id) async {
    dbRef
        .doc(id)
        .delete();
    return true;
  }

  Future updateDiscussion(TextEditingController nameInputController,
      TextEditingController titleInputController,
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
                  decoration: InputDecoration(
                      labelText: "Edit Title"
                  ),
                  controller: titleInputController,
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
                  titleInputController.clear();
                  descriptionInputController.clear();
                  Navigator.pop(context);
                },
                child: Text("Cancel")
            ),
            TextButton(
                onPressed: () {
                  if (nameInputController.text.isNotEmpty &&
                      titleInputController.text.isNotEmpty &&
                      descriptionInputController.text.isNotEmpty) {
                    dbRef.doc(snapshot.data.docs[index].id).update({
                      "uid": uid,
                      "name": nameInputController.text,
                      "title": titleInputController.text,
                      "description": descriptionInputController.text,
                      "timestamp": DateTime.now(),
                    }).then((_) {
                      nameInputController.clear();
                      titleInputController.clear();
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