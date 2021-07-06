import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpDashboardScreen extends StatefulWidget {

  @override
  _HelpDashboardScreenState createState() => _HelpDashboardScreenState();
}

class _HelpDashboardScreenState extends State<HelpDashboardScreen> {
  final String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kDarkBlue,
        title: Text(
          "Help with Dashboard",
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
                                Text('Targeted Expenditure Button',
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
                                  'Words on how to use',
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
                                Text('Cards Button',
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
                                  'Words on how to use',
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
                                Text('Budget Card',
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
                                  'Words on how to use',
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
                                Text('Expenses Breakdown Card',
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
                                  'Words on how to use',
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
                                Text('Expenses Summary Card',
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
                                  'Words on how to use',
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
                                Text('Expenses Receipts Card',
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
                                  'Words on how to use',
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
                                Text('Income Receipts Card',
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
                                  'Words on how to use',
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