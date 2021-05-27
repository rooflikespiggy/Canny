import 'package:Canny/Services/auth_comment.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CommentDetail extends StatelessWidget {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final dbRef = FirebaseFirestore.instance.collection("Forum");
  final dbCommentRef = FirebaseFirestore.instance.collection("ForumComment");
  final String inputId;

  CommentDetail(this.inputId);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColour,
      child: Column(
        children: <Widget>[
          StreamBuilder(
            stream: dbCommentRef
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
                      int noOfDislikes = snapshot.data.docs[index]["dislikes"];
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
                                          snapshot.data.docs[index]["name"],
                                          style: TextStyle(
                                            fontSize: 20,

                                          ),
                                        ),
                                        subtitle: Text(
                                            snapshot.data.docs[index]["description"],
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: kDeepOrangePrimary,
                                          radius: 30,
                                          child: Text(
                                            snapshot.data.docs[index]["name"][0],
                                            style: TextStyle(
                                              fontSize: 23,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(DateFormat("EEEE, d MMMM y")
                                              .format(DateTime.fromMillisecondsSinceEpoch(
                                              snapshot.data.docs[index]["timestamp"].seconds * 1000)),
                                          ),
                                        ],
                                      ),
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
                                                      snapshot.data.docs[index]["liked_uid"].contains(uid)
                                                          ? Icons.thumb_up_alt
                                                          : Icons.thumb_up_alt_outlined,
                                                      color: Colors.black),
                                                  onPressed: () async {
                                                    if (snapshot.data.docs[index]["liked_uid"].contains(uid)) {
                                                      await dbCommentRef
                                                          .doc(inputId)
                                                          .collection("Comment")
                                                          .doc(snapshot.data.docs[index].id)
                                                          .update({
                                                        "likes": noOfLikes -= 1,
                                                        "liked_uid": FieldValue.arrayRemove([uid]),
                                                      }).catchError((error) => print(error));
                                                    } else if (snapshot.data.docs[index]["disliked_uid"].contains(uid)) {
                                                      await dbCommentRef
                                                          .doc(inputId)
                                                          .collection("Comment")
                                                          .doc(snapshot.data.docs[index].id)
                                                          .update({
                                                        "likes": noOfLikes += 1,
                                                        "dislikes": noOfDislikes -= 1,
                                                        "liked_uid": FieldValue.arrayUnion([uid]),
                                                        "disliked_uid": FieldValue.arrayRemove([uid]),
                                                      }).catchError((error) => print(error));
                                                    } else {
                                                      await dbCommentRef
                                                          .doc(inputId)
                                                          .collection("Comment")
                                                          .doc(snapshot.data.docs[index].id)
                                                          .update({
                                                        "likes": noOfLikes += 1,
                                                        "liked_uid": FieldValue.arrayUnion([uid]),
                                                      }).catchError((error) => print(error));
                                                    }
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                      snapshot.data.docs[index]["disliked_uid"].contains(uid)
                                                          ? Icons.thumb_down_alt
                                                          : Icons.thumb_down_alt_outlined,
                                                      color: Colors.black),
                                                  onPressed: () async {
                                                    if (snapshot.data.docs[index]["disliked_uid"].contains(uid)) {
                                                      await dbCommentRef
                                                          .doc(inputId)
                                                          .collection("Comment")
                                                          .doc(snapshot.data.docs[index].id)
                                                          .update({
                                                        "dislikes": noOfDislikes -= 1,
                                                        "disliked_uid": FieldValue.arrayRemove([uid]),
                                                      }).catchError((error) => print(error));
                                                    } else if (snapshot.data.docs[index]["liked_uid"].contains(uid)) {
                                                      await dbCommentRef
                                                          .doc(inputId)
                                                          .collection("Comment")
                                                          .doc(snapshot.data.docs[index].id)
                                                          .update({
                                                        "likes": noOfLikes -= 1,
                                                        "dislikes": noOfDislikes += 1,
                                                        "liked_uid": FieldValue.arrayRemove([uid]),
                                                        "disliked_uid": FieldValue.arrayUnion([uid]),
                                                      }).catchError((error) => print(error));
                                                    }  else {
                                                      await dbCommentRef
                                                          .doc(inputId)
                                                          .collection("Comment")
                                                          .doc(snapshot.data.docs[index].id)
                                                          .update({
                                                        "dislikes": noOfDislikes += 1,
                                                        "disliked_uid": FieldValue.arrayUnion([uid]),
                                                      }).catchError((error) => print(error));
                                                    }
                                                  },
                                                ),
                                              ],
                                            )
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Row(
                                              children: <Widget> [
                                                if (snapshot.data.docs[index]["uid"] == uid)
                                                  IconButton(
                                                    icon:
                                                    Icon(FontAwesomeIcons.edit),
                                                    onPressed: () async {
                                                      await AuthCommentService(inputId).updateComment(
                                                          nameInputController,
                                                          descriptionInputController,
                                                          context,
                                                          snapshot,
                                                          index);
                                                    },
                                                  ),
                                                SizedBox(width: 10.0),
                                                if (snapshot.data.docs[index]["uid"] == uid)
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
                                                                  await AuthCommentService(inputId).removeComment(
                                                                    snapshot.data.docs[index].id,
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