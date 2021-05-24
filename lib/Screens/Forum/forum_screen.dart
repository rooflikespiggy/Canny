import 'package:Canny/Services/auth_forum.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ForumScreen extends StatefulWidget {
  static final String id = 'forum_screen';

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  final AuthForumService _auth = AuthForumService();
  final dbRef = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      TextEditingController nameInputController = TextEditingController(text: snapshot.data.docs[index]["name"]);
                      TextEditingController titleInputController = TextEditingController(text: snapshot.data.docs[index]["title"]);
                      TextEditingController descriptionInputController = TextEditingController(text: snapshot.data.docs[index]["description"]);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget> [
                            Container(
                              child: Card(
                                elevation: 9,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                child: Column(
                                  children: <Widget> [
                                    ListTile(
                                      contentPadding: EdgeInsets.all(18.0),
                                      title: Text(snapshot.data.docs[index]["title"]),
                                      subtitle: Text(snapshot.data.docs[index]["description"]),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        child: Text(snapshot.data.docs[index]["name"].toString()[0]),
                                      )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget> [
                                          Text("By: ${snapshot.data.docs[index]["name"]}"),
                                          Text(DateFormat("EEEE, d MMMM y")
                                              .format(DateTime.fromMillisecondsSinceEpoch(
                                              snapshot.data.docs[index]["timestamp"].seconds * 1000)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
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
                                          SizedBox(width: 145.0),
                                          if (snapshot.data.docs[index]["uid"] == uid)
                                            IconButton(
                                              icon: Icon(FontAwesomeIcons.edit),
                                                onPressed: () {
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
                                                }
                                            ),
                                          if (snapshot.data.docs[index]["uid"] == uid)
                                            IconButton(
                                              icon: Icon(FontAwesomeIcons.trashAlt),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
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
