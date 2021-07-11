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
                                  'Tap on the monthly Targeted Expenditure tile to change the '
                                    'targeted expenditure for the month. The default expenditure '
                                    'is set at \$500. \n \n'
                                      'If you enter an invalid expense amount (amount less than or equal to '
                                      'zero or infinity), there will be an error message displayed. \n \n'
                                      'Press on the "Submit" button to submit your target expenditure.' ,
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
                                  'Swipe right to view all the buttons that show what cards are '
                                      'displayed on the Dashboard page. \n \n'
                                      'Click on a button to go directly to the chosen card.',
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
                                Text('Balance Card',
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
                                  'A Balance card shows the sum of each Income-type and '
                                      'Expense-type in a bar separately. \n \n'
                                      'If the total income is more than the total expenses, '
                                      'the card will show the balance amount (difference between total '
                                      'income and total expenditure) but if the total '
                                      'expenses is more than the total income, the card will show '
                                      'the deficit amount (the absolute value of the difference between total '
                                      'income and total expenditure). \n \n'
                                      'This card will only be visible if the users have keyed in '
                                      'receipts with income, as the Balance card becomes meaningless '
                                      'with just expenses receipts.',
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
                                  'The expenses breakdown card shows a pie chart with the '
                                      'expenses amount for each Expense-type category. \n \n'
                                      'Click on each section to view the amount for '
                                      'each Expense-type category. \n \n'
                                      'If the total expenses is more than the targeted expenditure, '
                                      'the card will show the overspent amount but if the targeted '
                                      'expenditure is more than the total expenses, the card will show '
                                      'the amount left to spend.',
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
                                  'The expenses summary card shows the total amount for each Expense-type '
                                      'category and the percentage of the category with respect to the '
                                      'targeted expenditure. \n \n '
                                      'If the total expenses exits the targeted expenditure, the percentage '
                                      'shown will be with respect to the total expenses. \n \n'
                                      'The top 5 category amount tiles will be shown. Click “show more” '
                                      'to view the summary for the other categories.',
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
                                  'The expenses receipts card shows the top 5 expenses receipts based on the '
                                      'spending amount. If there are no added expenses receipts yet, the card will '
                                      'be empty. \n \n'
                                      'Click “show more” to view all other expenses receipts.',
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
                                  'The income receipts card shows the top 5 income receipts based on the '
                                      'spending amount. If there are no added income receipts yet, the card will '
                                      'be empty. \n \n'
                                      'Click “show more” to view all other income receipts.',
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