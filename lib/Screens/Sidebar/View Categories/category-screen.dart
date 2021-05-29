import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Screens/Sidebar/sidebar_menu.dart';
import 'package:Canny/Shared/category_tiles.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Canny/Services/Users/category-database.dart';
import 'package:provider/provider.dart';
import 'package:Canny/Screens/Sidebar/View Categories/category-list.dart';
import 'package:Canny/Shared/category.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Category>>.value(
      value: CategoryDatabaseService().categories,
      child: Scaffold(
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
        body: CategoryList(),
      ),
    );
  }
}
