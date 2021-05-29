import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Screens/Sidebar/sidebar_menu.dart';
import 'package:Canny/Shared/category_tiles.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Canny/Services/Category/category-database.dart';
import 'package:Canny/Services/Category/categorylist.dart';
import 'package:Canny/Models/category';

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
        body: SingleChildScrollView(
            child: Container(
            child: Column(
              children: <Widget>[
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Categories").snapshots(),
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
                            final snapshotData = snapshot.data.docs[index];
                            return CategoryTile(
                              categoryName: snapshotData['categoryName'],
                              categoryColor: snapshotData['categoryColor'],
                              categoryIcon: snapshotData['categoryIcon'],
                            );
                          },
                        )
                      );
                    }
                    return CircularProgressIndicator();
                  }
                )
              ],
            )
          )
        ),
      );
  }
}