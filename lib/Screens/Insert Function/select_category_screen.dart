import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Services/Category/default_categories.dart';
import 'package:Canny/Screens/Category/category_tiles.dart';
import 'package:Canny/Services/Quick%20Input/quickinput_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SelectCategoryScreen extends StatefulWidget {

  @override
  _SelectCategoryScreenState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final QuickInputDatabaseService _authQuickInput = QuickInputDatabaseService();
  final int categoriesSize = defaultCategories.length;
  bool isDefault = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kDarkBlue,
        title: Text(
          "Select Category",
          style: TextStyle(fontFamily: 'Lato'),
        ),
        actions: <Widget> [
          IconButton(
            icon: Icon(
                isDefault ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              print(_authQuickInput.allQuickInputs);
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
                      width: 360,
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
                                      isIncome: snapshotData['isIncome'],
                                      tappable: true
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
      ),
    );
  }
}