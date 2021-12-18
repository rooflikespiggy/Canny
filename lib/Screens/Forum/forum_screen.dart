import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Screens/Forum/forum_detail_screen.dart';
import 'package:Canny/Screens/Sidebar/sidebar_menu.dart';
import 'package:Canny/Services/Forum/forum_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Shared/custom_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_discussion.dart';
import 'forum_search.dart';

class ForumScreen extends StatefulWidget {

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final ForumDatabaseService _authForum = ForumDatabaseService();
  final CollectionReference forumCollection = Database().forumDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColour,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kDarkBlue,
        title: Text(
          "FORUM",
          style: TextStyle(fontFamily: 'Lato'),
        ),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context,
                  delegate: ForumSearch());
            },
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline_sharp),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddDiscussion()));
            },
          ),
        ],
      ),
      drawer: SideBarMenu(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        backgroundColor: kDarkBlue,
        color: Colors.white,
        child: Container(
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
            child: Center(
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    StreamBuilder(
                      stream: forumCollection
                          .orderBy("datetime", descending: true)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                              padding: EdgeInsets.all(10),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final nameInputController = TextEditingController(text: snapshot.data.docs[index]["name"]);
                                final titleInputController = TextEditingController(text: snapshot.data.docs[index]["title"]);
                                final descriptionInputController = TextEditingController(text: snapshot.data.docs[index]["description"]);
                                int noOfLikes = snapshot.data.docs[index]["likes"];
                                int noOfComments = snapshot.data.docs[index]["comments"];
                                final snapshotData = snapshot.data.docs[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 4.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Card(
                                          color: Colors.white.withOpacity(0.9),
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                          child: Column(
                                            children: <Widget>[
                                              ListTile(
                                                  contentPadding: EdgeInsets.all(18.0),
                                                  title: Text(
                                                    snapshotData["title"],
                                                    style: TextStyle(
                                                      fontFamily: 'Lato-Thin',
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  subtitle: Padding(
                                                    padding: const EdgeInsets.only(top: 8.0),
                                                    child: AutolinkText(
                                                      text: snapshotData["description"].length > 500
                                                          ? snapshotData["description"].substring(0, 500) + "..."
                                                          : snapshotData["description"],
                                                      textStyle: TextStyle(
                                                        fontFamily: 'Lato-Thin',
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                      linkStyle: TextStyle(
                                                        fontFamily: 'Lato-Thin',
                                                        color: Colors.blue,
                                                        fontSize: 15),
                                                      humanize: false,
                                                      onWebLinkTap: (link) => _launchInWebViewOrVC(link),
                                                      onEmailTap: (link) => _launchEmail(link),
                                                    ),
                                                  ),
                                                  /*
                                                  Text(
                                                      snapshotData["description"].length > 200
                                                          ? snapshotData["description"].substring(0, 200) + "..."
                                                          : snapshotData["description"],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      )
                                                  ),
                                                   */
                                                  leading: CircleAvatar(
                                                    backgroundColor: kPalePurple,
                                                    radius: 30,
                                                    child: Text(
                                                      snapshotData["name"][0],
                                                      style: TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 23,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder: (context) =>
                                                          ForumDetailScreen(inputId: snapshotData.id)));
                                                },
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text("By: ${snapshotData["name"]}",
                                                      style: TextStyle(
                                                        fontFamily: 'Lato-Thin',
                                                        fontSize: 14,
                                                        color: Colors.grey[800],
                                                      )
                                                    ),
                                                    Text(DateFormat("EEEE, d MMMM y")
                                                        .format(DateTime.fromMillisecondsSinceEpoch(
                                                        snapshotData["datetime"].seconds * 1000)),
                                                        style: TextStyle(
                                                          fontFamily: 'Lato-Thin',
                                                          fontSize: 14,
                                                          color: Colors.grey[800],
                                                        )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 8.0, right: 8.0),
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
                                                                    ? Icons.favorite
                                                                    : Icons.favorite_border,
                                                                color: snapshotData["liked_uid"].contains(uid)
                                                                    ? Colors.red
                                                                    : Colors.black),
                                                            onPressed: () {
                                                               _authForum.updateLikes(
                                                                  snapshotData["liked_uid"],
                                                                  snapshotData.id);
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: Icon(Icons.add_comment_outlined),
                                                            onPressed: () {
                                                              Navigator.push(context,
                                                                  MaterialPageRoute(builder: (context) =>
                                                                      ForumDetailScreen(inputId: snapshotData.id)));
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Row(
                                                        children: <Widget> [
                                                          Visibility(
                                                            visible: snapshotData["uid"] == uid,
                                                            child: IconButton(
                                                              icon:
                                                              Icon(FontAwesomeIcons.edit),
                                                              onPressed: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      backgroundColor: kLightBlue,
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
                                                                          SizedBox(height: 15),
                                                                          TextField(
                                                                            decoration: InputDecoration(
                                                                                labelText: "Edit Title"
                                                                            ),
                                                                            controller: titleInputController,
                                                                          ),
                                                                          SizedBox(height: 15),
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
                                                                        SizedBox(
                                                                          width: 130,
                                                                          child: TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                },
                                                                            child: Text("Cancel",
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            style: TextButton.styleFrom(
                                                                              backgroundColor: kDarkBlue,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 130,
                                                                          child: TextButton(
                                                                              onPressed: () {
                                                                                if (nameInputController.text.isNotEmpty &&
                                                                                    titleInputController.text.isNotEmpty &&
                                                                                    descriptionInputController.text.isNotEmpty) {
                                                                                  _authForum.updateDiscussion(snapshotData.id,
                                                                                      nameInputController.text,
                                                                                      titleInputController.text,
                                                                                      descriptionInputController.text).then((_) {
                                                                                        FocusScope.of(context).unfocus();
                                                                                        Navigator.pop(context);
                                                                                        Flushbar(
                                                                                          message: "Discussion successfully edited.",
                                                                                          icon: Icon(
                                                                                            Icons.check,
                                                                                            size: 28.0,
                                                                                            color: kLightBlueDark,
                                                                                          ),
                                                                                          duration: Duration(seconds: 3),
                                                                                          leftBarIndicatorColor: kLightBlueDark,
                                                                                        )..show(context);
                                                                                      }).catchError((error) => print(error));
                                                                                }
                                                                              },
                                                                            child: Text("Update",
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            style: TextButton.styleFrom(
                                                                              backgroundColor: kDarkBlue,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(width: 8.0),
                                                          Visibility(
                                                            visible: snapshotData["uid"] == uid,
                                                            child: IconButton(
                                                              icon: Icon(
                                                                FontAwesomeIcons.trashAlt),
                                                                onPressed: () {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        backgroundColor: kLightBlue,
                                                                        title: Text("Are you sure you want to delete your discussion?"),
                                                                        content: Text("Once your discussion is deleted, you will not be able to retrieve it back."),
                                                                        actions: <Widget>[
                                                                          // usually buttons at the bottom of the dialog
                                                                          SizedBox(
                                                                            width: 120,
                                                                            child: TextButton(
                                                                              child: Text("Yes",
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              style: TextButton.styleFrom(
                                                                                backgroundColor: kDarkBlue,
                                                                              ),
                                                                            onPressed: () {
                                                                              _authForum.removeDiscussion(
                                                                                snapshotData.id,
                                                                              );
                                                                              setState(() {
                                                                                snapshot.data.docs.removeAt(index);
                                                                              });
                                                                              Navigator.pop(context, true);
                                                                              Flushbar(
                                                                                message: "Discussion deleted.",
                                                                                icon: Icon(
                                                                                  Icons.check,
                                                                                  size: 28.0,
                                                                                  color: kLightBlueDark,
                                                                                ),
                                                                                duration: Duration(seconds: 3),
                                                                                leftBarIndicatorColor: kLightBlueDark,
                                                                              )..show(context);
                                                                            },
                                                                          ),),
                                                                          SizedBox(
                                                                            width: 120,
                                                                            child: TextButton(
                                                                              child: Text("No",
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              style: TextButton.styleFrom(
                                                                                backgroundColor: kDarkBlue,
                                                                              ),
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),),
                                                                          SizedBox(width: 10)
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget> [
                                                      SizedBox(width: 20),
                                                      Text(
                                                        noOfLikes.toString(),
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      SizedBox(width: 40.5),
                                                      Text(
                                                        noOfComments.toString(),
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
                    SizedBox(height: 50.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchInWebViewOrVC(String url) async {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
    /*
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
     */
  }

  Future<void> _launchEmail(String url) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: url,
    );
    String newUrl = params.toString();
    await launch(newUrl);
    /*
    if (await canLaunch(newUrl)) {
      await launch(newUrl);
    } else {
      throw 'Could not launch $newUrl';
    }
     */
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {});
  }
}
