import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpQuickInputScreen extends StatefulWidget {

  @override
  _HelpQuickInputScreenState createState() => _HelpQuickInputScreenState();
}

class _HelpQuickInputScreenState extends State<HelpQuickInputScreen> {
  final String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kDarkBlue,
        title: Text(
          "Help with Quick Input",
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0))),
                        color: Colors.white.withOpacity(0.9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget> [
                            SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget> [
                                SizedBox(width: 15.0),
                                Text('Quick Input Calculator',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Lato",
                                      color: kDarkBlue
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                              child: Divider(thickness: 2.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Enter your expenses amount and choose a category by pressing one of the '
                                      'three category buttons. \n \n'
                                      'If you do not choose a category or if you enter an invalid expense amount (amount less than or equal to '
                                      'zero or infinity), there will be an error message displayed. \n \n'
                                      'Press on the "Submit" button to submit your expenses.',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato=Thin'
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0))),
                        color: Colors.white.withOpacity(0.9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget> [
                            SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget> [
                                SizedBox(width: 15.0),
                                Text('Customise Quick Input Category Buttons',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Lato",
                                      color: kDarkBlue
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                              child: Divider(thickness: 2.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'At the Customise Quick Input Screen which can be found on the sidebar, '
                                      'tap on "Tap to select Categories for Quick Input" text to '
                                      'choose your 3 category buttons for the Quick Input screen. '
                                      'Press on "Apply" after selecting the 3 categories. \n \n'
                                      'The selected 3 category chips will appear on the screen. If you select less '
                                      'than 3 categories to submit, there will be an error message displayed. Ensure '
                                      'that you have selected 3 categories before submitting. \n \n'
                                      'Press on the "Submit" button to submit your customised category choices.',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato=Thin'
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}