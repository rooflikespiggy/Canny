import 'package:Canny/Screens/Dashboard/dashboard_screen.dart';
import 'package:Canny/Screens/Forum/forum_screen.dart';
import 'package:Canny/Screens/Insert Function/add_category.dart';
import 'package:Canny/Screens/Insert Function/add_spending.dart';
import 'package:Canny/Screens/Insert Function/add_targeted_expenditure.dart';
import 'package:Canny/Screens/Leaderboard/leaderboard_screen.dart';
import 'package:Canny/Screens/Receipt/receipt_screen.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePageScreen extends StatefulWidget {
  static final String id = 'homepage_screen';

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedTab = 0;
  // String _title = 'CANNY';


  @override
  Widget build(BuildContext context) {

    List<Widget> _pageOptions = [
      DashboardScreen(),
      ReceiptScreen(),
      ForumScreen(),
    ];

    List<BottomNavigationBarItem> _items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.view_list),
        label: 'Receipt',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.forum),
        label: 'Forum',
      ),
      /*
    BottomNavigationBarItem(
      icon: Icon(Icons.leaderboard),
      label: 'Leaderboard',
    ),
     */
    ];

    List<SpeedDialChild> _speedDailItems = [
      SpeedDialChild(
        child: Icon(Icons.monetization_on_outlined),
        label: 'Add your Spendings',
        backgroundColor: Colors.redAccent,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddSpendingScreen()));
          // print("Add Spending");
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.star),
        label: 'Enter your Target Expenditure',
        backgroundColor: Colors.lightBlueAccent,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTEScreen()));
          // print('Add Target Expenditure');
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.category),
        label: 'Add a new Category',
        backgroundColor: Colors.greenAccent,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddCategoryScreen()));
          // print('Add Target Category');
        },
      ),
    ];

    return Scaffold(
      body: _pageOptions[_selectedTab],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(right: 80),
        child: BottomNavigationBar(
          elevation: 0.0,
          currentIndex: _selectedTab,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: kDeepOrangeLight,
          selectedItemColor: kDeepOrange,
          selectedLabelStyle: TextStyle(fontFamily: 'Lato'),
          unselectedLabelStyle: TextStyle(fontFamily: 'Lato'),
          onTap: (int index) {
            setState(() {
              _selectedTab = index;
            });
          },
          items: _items,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SpeedDial(
        marginBottom: 20,
        icon: Icons.menu,
        activeIcon: Icons.clear,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        backgroundColor: kDeepOrangePrimary,
        shape: CircleBorder(),
        buttonSize: 50.0,
        childMarginTop: 15.0,
        childMarginBottom: 15.0,
        children: _speedDailItems,
      ),
    );
  }
}
