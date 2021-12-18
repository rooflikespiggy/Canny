import 'package:Canny/Screens/Help%20Center/help_tiles.dart';
import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {

  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final List<String> helpNames = ['Quick Input', 'Dashboard', 'Receipt', 'Categories', 'Forum'];
  final List<Icon> helpIcons = [
    Icon(Icons.calculate_rounded),
    Icon(Icons.dashboard),
    Icon(Icons.view_list),
    Icon(Icons.category),
    Icon(Icons.forum)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kDarkBlue,
        title: Text(
          "Help Center",
          style: TextStyle(fontFamily: 'Lato'),
        ),
        actions: <Widget> [
          IconButton(
            icon: Icon(
              Icons.home_filled,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePageScreen(selectedTab: 0)));
            },
          ),
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
                children: <Widget>[
                  SizedBox(height: 5.0),
                  Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: helpNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return HelpTile(
                            name: helpNames[index],
                            icon: helpIcons[index]
                          );
                        },
                      )
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}