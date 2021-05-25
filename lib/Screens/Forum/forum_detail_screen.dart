import 'package:Canny/Screens/Forum/add_comment.dart';
import 'package:Canny/Screens/Forum/forum_screen.dart';
import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Shared/icon_with_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'comment_detail.dart';

class ForumDetailScreen extends StatefulWidget {
  static final String id = 'individual_forum_screen';
  final String inputId;

  ForumDetailScreen({this.inputId});

  @override
  _ForumDetailScreenState createState() => _ForumDetailScreenState(this.inputId);
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  final dbRef = FirebaseFirestore.instance.collection("Forum");
  final dbCommentRef = FirebaseFirestore.instance.collection("ForumComment");
  final String inputId;
  final String uid = FirebaseAuth.instance.currentUser.uid;

  _ForumDetailScreenState(this.inputId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePageScreen()));
          },
        ),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.add_circle_outline_sharp),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddComment(inputId: inputId)));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: kBackgroundColour,
          child: Column(
            children: <Widget> [
              StreamBuilder<DocumentSnapshot>(
                stream: dbRef.doc(inputId).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot>snapshot) {
                  if (snapshot.hasData) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: <Widget> [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget> [
                                ListTile(
                                  contentPadding: EdgeInsets.all(8.0),
                                  title: Text(
                                    snapshot.data["title"],
                                    textScaleFactor: 1.5,
                                  ),
                                  subtitle: Text(snapshot.data["description"]),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("By: ${snapshot.data["name"]}"),
                                      Text(DateFormat("EEEE, d MMMM y")
                                          .format(DateTime.fromMillisecondsSinceEpoch(
                                          snapshot.data["timestamp"].seconds * 1000)),
                                      ),
                                      IconWithText(
                                        Icons.add_comment_outlined,
                                        snapshot.data['comments'].toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            )
                          )
                        ]
                      )
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
              Divider(),
              CommentDetail(inputId),
            ],
          ),
        ),
      ),
    );
  }
}