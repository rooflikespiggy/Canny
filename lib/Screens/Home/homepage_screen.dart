import 'package:Canny/Screens/Dashboard/dashboard_screen.dart';
import 'package:Canny/Screens/Forum/forum_screen.dart';
import 'package:Canny/Screens/Leaderboard/leaderboard_screen.dart';
import 'package:Canny/Screens/Receipt/receipt_screen.dart';
import 'package:Canny/Services/auth.dart';
import 'package:flutter/material.dart';

import '../wrapper.dart';

class HomePageScreen extends StatefulWidget {
  static final String id = 'homepage_screen';

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  AuthService _auth = AuthService();
  int _selectedTab = 0;
  String _title = 'CANNY';

  List<Widget> _pageOptions = [
    DashboardScreen(),
    ReceiptScreen(),
    ForumScreen(),
    LeaderboardScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: TextStyle(fontFamily: 'Lato'),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                await _auth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Wrapper()));
              },
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      drawer: Drawer(),
      body: _pageOptions[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blueAccent,
        selectedLabelStyle: TextStyle(fontFamily: 'Lato'),
        unselectedLabelStyle: TextStyle(fontFamily: 'Lato-Thin'),
        onTap: (int index) {
          setState(() {
            _selectedTab = index;
            switch (index) {
              case 0:
                {_title = 'DASHBOARD';}
                break;
              case 1:
                {_title = 'RECEIPT';}
                break;
              case 2:
                {_title = 'FORUM';}
                break;
              case 3:
                {_title = 'LEADERBOARD';}
                break;
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Receipt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
            showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              )),
              isScrollControlled: true,
              elevation: 5,
              context: context,
              builder: (context) =>
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                    leading: Icon(Icons.money),
                    title: Text('Add Spending'),
                    onTap: () {
                      print("Add Spending");
                    }),
                ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Add Target Expenditure'),
                    onTap: () {
                      print('Add Target Expenditure');
                    }),
                ListTile(
                    leading: Icon(Icons.category),
                    title: Text('Add Category'),
                    onTap: () {
                      print('Add Category');
                    }),
              ]),
            );
          }),
    );
  }
}
