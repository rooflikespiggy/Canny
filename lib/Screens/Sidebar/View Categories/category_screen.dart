import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Screens/Sidebar/sidebar_menu.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Services/Category/default_categories.dart';
import 'package:Canny/Shared/category_tiles.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CategoryScreen extends StatefulWidget {

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
  final int categoriesSize = defaultCategories.length;

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
                        stream: categoryCollection
                            .orderBy("categoryId")
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return Align(
                                alignment: Alignment.topCenter,
                                child: ListView.builder(
                                  padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final snapshotData = snapshot.data.docs[index];
                                    if (index >= categoriesSize) {
                                      return Dismissible(
                                        child: CategoryTile(
                                          categoryName: snapshotData['categoryName'],
                                          categoryColorValue: snapshotData['categoryColorValue'],
                                          categoryIconCodePoint: snapshotData['categoryIconCodePoint'],
                                          categoryId: snapshotData.id,
                                        ),
                                        key: ValueKey(snapshotData),
                                        onDismissed: (DismissDirection direction) {
                                          _authCategory.removeCategory(snapshotData.id);
                                          setState(() {
                                            snapshot.data.docs.removeAt(index);
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(content: Text(snapshotData['categoryName'] + ' deleted')));
                                        },
                                        direction: DismissDirection.endToStart,
                                        background: Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                          color: Colors.red,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Icon(
                                                FontAwesomeIcons.trashAlt,
                                                color: Colors.white,
                                              ),
                                            )
                                          )
                                        ),
                                      );
                                    }
                                    return CategoryTile(
                                      categoryName: snapshotData['categoryName'],
                                      categoryColorValue: snapshotData['categoryColorValue'],
                                      categoryIconCodePoint: snapshotData['categoryIconCodePoint'],
                                      categoryId: snapshotData.id,
                                    );
                                  },
                                )
                            );
                          }
                          return CircularProgressIndicator();
                        }
                    ),
                  ],
                ),
            )
        ),
    );
  }
}