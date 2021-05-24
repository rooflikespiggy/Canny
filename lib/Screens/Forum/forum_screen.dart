import 'package:Canny/Services/auth_forum.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForumScreen extends StatefulWidget {
  static final String id = 'forum_screen';

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  final AuthForumService _auth = AuthForumService();
  final dbRef = FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('Title');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColour,
      body: Container(
        color: kBackgroundColour,
        child: Center(
          child: StreamBuilder(
            stream: dbRef.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 10.0),
                                  Text("Name: " + snapshot.data.docs[index]["name"]),
                                  Divider(),
                                  SizedBox(height: 10.0),
                                  Text("Title: " + snapshot.data.docs[index]["title"]),
                                  SizedBox(height: 10.0),
                                  Text("Description: "),
                                  SizedBox(height: 10.0),
                                  Text(snapshot.data.docs[index]["description"]),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.favorite),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.comment),
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 225.0),
                                  IconButton(
                                    icon: Icon(Icons.delete_forever),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          // return object of type Dialog
                                          return AlertDialog(
                                            title: Text("Are you sure you want to delete your discussion"),
                                            content: Text("Once your discussion is deleted, you will not be able to retrieve it back."),
                                            actions: <Widget>[
                                              // usually buttons at the bottom of the dialog
                                              TextButton(
                                                child: Text("Yes"),
                                                onPressed: () async {
                                                  await _auth.removeDiscussion(
                                                    snapshot.data.docs[index].id,
                                                  );
                                                  setState(() {
                                                    snapshot.data.docs.removeAt(index);
                                                  });
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
        ),
      ),
    );
  }
}
