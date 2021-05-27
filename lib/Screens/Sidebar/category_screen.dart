import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Screens/Sidebar/sidebar_menu.dart';
import 'package:Canny/Shared/category_tiles.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColour,
      drawer: SideBarMenu(),
      appBar: AppBar(
        backgroundColor: kDeepOrangePrimary,
        title: Text(
          "CATEGORIES",
          style: TextStyle(fontFamily: 'Lato'),
        ),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.home_rounded),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePageScreen()));
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          CategoryTile(
            categoryName: "Food and Drinks",
            categoryColor: Colors.green[800],
            categoryIcon: FaIcon(FontAwesomeIcons.hamburger),
          ),
          CategoryTile(
            categoryName: "Transportation",
            categoryColor: Colors.red[800],
            categoryIcon: FaIcon(FontAwesomeIcons.car),
          ),
          CategoryTile(
            categoryName: "Shopping",
            categoryColor: Colors.pinkAccent,
            categoryIcon: FaIcon(FontAwesomeIcons.shoppingBag),
          ),
          CategoryTile(
            categoryName: "Entertainment",
            categoryColor: Colors.deepOrange,
            categoryIcon: FaIcon(FontAwesomeIcons.film),
          ),
          CategoryTile(
            categoryName: "Bills and Fees",
            categoryColor: Colors.purple[800],
            categoryIcon: FaIcon(FontAwesomeIcons.fileInvoiceDollar),
          ),
          CategoryTile(
            categoryName: "Education",
            categoryColor: Colors.blue,
            categoryIcon: FaIcon(FontAwesomeIcons.graduationCap),
          ),
          CategoryTile(
            categoryName: "Gift",
            categoryColor: Colors.amber[700],
            categoryIcon: FaIcon(FontAwesomeIcons.gift),
          ),
          CategoryTile(
            categoryName: "Household",
            categoryColor: Colors.teal,
            categoryIcon: FaIcon(FontAwesomeIcons.couch),
          ),
          CategoryTile(
            categoryName: "Allowance",
            categoryColor: Colors.indigo[600],
            categoryIcon: FaIcon(FontAwesomeIcons.handHoldingUsd),
          ),
          CategoryTile(
            categoryName: "Salary",
            categoryColor: Colors.pink[900],
            categoryIcon: FaIcon(FontAwesomeIcons.moneyBillWave),
          ),
          CategoryTile(
            categoryName: "Loan",
            categoryColor: Colors.orange,
            categoryIcon: FaIcon(FontAwesomeIcons.landmark),
          ),
          CategoryTile(
            categoryName: "Other",
            categoryColor: Colors.grey[800],
            categoryIcon: FaIcon(FontAwesomeIcons.archive),
          ),
        ]
      )
    );
  }
}
