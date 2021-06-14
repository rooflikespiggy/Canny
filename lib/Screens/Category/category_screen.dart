import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Screens/Sidebar/sidebar_menu.dart';
import 'package:Canny/Services/Category/default_categories.dart';
import 'package:Canny/Screens/Category/category_tiles.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CategoryScreen extends StatefulWidget {

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final int categoriesSize = defaultCategories.length;
  bool isDefault = true;
  final String monthYear = DateFormat('MMM y').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBarMenu(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kDarkBlue,
          title: Text(
            "CATEGORIES",
            style: TextStyle(fontFamily: 'Lato'),
          ),
          actions: <Widget> [
            IconButton(
              icon: Icon(
                  isDefault ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isDefault = !isDefault;
                });
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
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5.0),
                      Visibility(
                        visible: !isDefault,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.green[200].withOpacity(0.8),
                          ),
                          child: Text(
                            "Only Non-Default Categories shown",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder(
                          stream: categoryCollection
                          .where("categoryAmount")
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
                                      if (!isDefault && index < 12) {
                                        return SizedBox();
                                      }
                                      return CategoryTile(
                                          categoryName: snapshotData['categoryName'],
                                          categoryColorValue: snapshotData['categoryColorValue'],
                                          categoryIconCodePoint: snapshotData['categoryIconCodePoint'],
                                          categoryFontFamily: snapshotData['categoryFontFamily'],
                                          categoryFontPackage: snapshotData['categoryFontPackage'],
                                          categoryId: snapshotData.id,
                                          categoryAmount: snapshotData['categoryAmount'],
                                          isIncome: snapshotData['isIncome'],
                                          tappable: false
                                      );
                                    },
                                  )
                              );
                            }
                            return CircularProgressIndicator();
                          }
                      ),
                      SizedBox(height: 50.0),
                    ],
                  ),
              )
          ),
        ),
    );
  }

  Stream<QuerySnapshot> getData() async* {
    //await Future.delayed(const Duration(milliseconds: 300));
    yield* categoryCollection
        .orderBy("categoryId")
        .snapshots();
  }
}