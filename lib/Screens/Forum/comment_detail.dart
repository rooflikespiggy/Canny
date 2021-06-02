import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Services/Forum/comment_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CommentDetail extends StatelessWidget {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final CollectionReference forumCommentCollection = Database().forumCommentDatabase();
  final String inputId;

  CommentDetail(this.inputId);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColour,
      child: Column(
        children: <Widget>[
          StreamBuilder(
            stream: forumCommentCollection
                .doc(inputId)
                .collection("Comment")
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final nameInputController = TextEditingController(text: snapshot.data.docs[index]["name"]);
                      final descriptionInputController = TextEditingController(text: snapshot.data.docs[index]["description"]);
                      int noOfLikes = snapshot.data.docs[index]["likes"];
                      print(noOfLikes);
                      int noOfDislikes = snapshot.data.docs[index]["dislikes"];
                      final snapshotData = snapshot.data.docs[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Card(
                                elevation: 9,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                        contentPadding: EdgeInsets.all(18.0),
                                        title: Text(
                                          snapshotData["name"],
                                          style: TextStyle(
                                            fontSize: 20,

                                          ),
                                        ),
                                        subtitle: Text(
                                          snapshotData["description"],
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: kDeepOrangePrimary,
                                          radius: 30,
                                          child: Text(
                                            snapshotData["name"][0],
                                            style: TextStyle(
                                              fontSize: 23,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: <Widget> [
                                                  IconButton(
                                                      icon: Icon(
                                                          snapshotData["liked_uid"].contains(uid)
                                                              ? Icons.thumb_up_alt
                                                              : Icons.thumb_up_alt_outlined,
                                                          color: Colors.black),
                                                      onPressed: () async {
                                                        await CommentDatabaseService(inputId).updateLikes(snapshotData["liked_uid"],
                                                            snapshotData["disliked_uid"],
                                                            snapshotData.id);
                                                      }
                                                  ),
                                                  IconButton(
                                                      icon: Icon(
                                                          snapshotData["disliked_uid"].contains(uid)
                                                              ? Icons.thumb_down_alt
                                                              : Icons.thumb_down_alt_outlined,
                                                          color: Colors.black),
                                                      onPressed: () async {
                                                        await CommentDatabaseService(inputId).updateDislikes(snapshotData["liked_uid"],
                                                            snapshotData["disliked_uid"],
                                                            snapshotData.id);
                                                      }
                                                  ),
                                                ],
                                              )
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                children: <Widget> [
                                                  if (snapshotData["uid"] == uid)
                                                    IconButton(
                                                      icon:
                                                      Icon(FontAwesomeIcons.edit),
                                                      onPressed: () async {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              contentPadding: EdgeInsets.all(20),
                                                              content: Column(
                                                                children: <Widget> [
                                                                  Text("Update discussion"),
                                                                  TextField(
                                                                    decoration: InputDecoration(
                                                                        labelText: "Edit Name"
                                                                    ),
                                                                    controller: nameInputController,
                                                                  ),
                                                                  SizedBox(height: 20),
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
                                                                    onPressed: () async {
                                                                      if (nameInputController.text.isNotEmpty &&
                                                                          descriptionInputController.text.isNotEmpty) {
                                                                        await CommentDatabaseService(inputId).updateComment(
                                                                            snapshotData.id,
                                                                            nameInputController.text,
                                                                            descriptionInputController.text
                                                                        ).then((_) {
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
                                                      },
                                                    ),
                                                  SizedBox(width: 10.0),
                                                  if (snapshotData["uid"] == uid)
                                                    IconButton(
                                                      icon: Icon(
                                                          FontAwesomeIcons.trashAlt),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder:
                                                              (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text("Are you sure you want to delete your discussion"),
                                                              content: Text("Once your discussion is deleted, you will not be able to retrieve it back."),
                                                              actions: <Widget>[
                                                                // usually buttons at the bottom of the dialog
                                                                TextButton(
                                                                  child: Text("Yes"),
                                                                  onPressed: () async {
                                                                    await CommentDatabaseService(inputId).removeComment(
                                                                      snapshotData.id,
                                                                    );
                                                                    snapshot.data.docs.removeAt(index);
                                                                    Navigator.pop(context);
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
                                                      },
                                                    ),
                                                ],
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 15),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget> [
                                            SizedBox(width: 18.5),
                                            Text(
                                              noOfLikes.toString(),
                                            ),
                                            SizedBox(width: 40.5),
                                            Text(
                                              noOfDislikes.toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}