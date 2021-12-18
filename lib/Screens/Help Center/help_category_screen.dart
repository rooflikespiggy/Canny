import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpCategoryScreen extends StatefulWidget {

  @override
  _HelpCategoryScreenState createState() => _HelpCategoryScreenState();
}

class _HelpCategoryScreenState extends State<HelpCategoryScreen> {
  final String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kDarkBlue,
        title: Text(
          "Help with Categories",
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
                                Text('Adding of Categories',
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
                                  'To add a category, tap on the circular floating button at the bottom '
                                      'of the screen, then tap "Add Category". \n \n'
                                      'Key in the name of the new category, and pick a suitable category colour '
                                      'and icon from the range of colours and icons provided. If a colour or '
                                      'an icon is not chosen, the default colour and icon will be used. Indicate if '
                                      'the new category will be an expense or an income category. An expense category '
                                      'deducts money from the total amount, while an income category adds money to the '
                                      'total amount.\n \n'
                                      'Press on the "Submit" button to submit your new category.',
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
                                Text('Editing of Non-Default Categories',
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
                                  'Only non-default categories (categories added by the user) can be edited. \n \n'
                                      'To edit a category, go to the "Categories" screen and tap on the pencil icon of '
                                      'the non-default category tile. The name, colour, icon and category type of a category '
                                      'can be edited. \n \n'
                                      'The fields will already be filled in based on the previous inputs. \n \n'
                                      'Press on the "Submit" button to submit the edited category.',
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
                                Text('Deleting of Non-Default Categories',
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
                                  'Only non-default categories (categories added by the user) can be deleted. \n \n'
                                      'To delete a category, go to the "Categories" screen and tap on the bin icon of '
                                      'the non-default category tile. A message box will pop up to confirm receipt '
                                      'deletion.\n \n'
                                      'By clicking "Yes", the category can no longer be recovered, and all receipts '
                                      'for that category will be moved to the "Others" category.',
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
                                Text('Filtering of Non-Default Categories',
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
                                  'To view only non-default categories, tap the eye icon at the top of the '
                                      '"Categories" page. To undo, tap on the eye again to view both default '
                                      'and non-default categories.',
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