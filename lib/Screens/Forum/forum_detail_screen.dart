import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Screens/Forum/add_comment.dart';
import 'package:Canny/Screens/Forum/comment_detail.dart';
import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Shared/icon_with_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ForumDetailScreen extends StatefulWidget {
  static final String id = 'individual_forum_screen';
  final String inputId;

  ForumDetailScreen({this.inputId});

  @override
  _ForumDetailScreenState createState() => _ForumDetailScreenState(this.inputId);
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  final String inputId;
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final CollectionReference forumCollection = Database().forumDatabase();

  _ForumDetailScreenState(this.inputId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColour,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 0.0,
        title: Text('COMMENTS'),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePageScreen(selectedTab: 3)));
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("styles/images/background-2.png"),
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget> [
                StreamBuilder<DocumentSnapshot>(
                  stream: forumCollection.doc(inputId).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      //print(snapshot.data);
                      //print(snapshot);
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
                                      style: TextStyle(
                                        fontFamily: 'Lato-Thin',
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        snapshot.data["description"],
                                        style: TextStyle(
                                          fontFamily: 'Lato-Thin',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "By: ${snapshot.data["name"]}",
                                          style: TextStyle(
                                            fontFamily: 'Lato-Thin',
                                          ),
                                        ),
                                        Text(
                                          DateFormat("EEEE, d MMMM y")
                                            .format(DateTime.fromMillisecondsSinceEpoch(
                                            snapshot.data["datetime"].seconds * 1000)),
                                          style: TextStyle(
                                            fontFamily: 'Lato-Thin',
                                          ),
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
                Divider(
                    thickness: 2.0,
                  color: Colors.black.withOpacity(0.4),
                  indent: 20,
                  endIndent: 20,
                ),
                CommentDetail(inputId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}