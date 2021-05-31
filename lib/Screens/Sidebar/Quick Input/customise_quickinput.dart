import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Services/Quick%20Input/quickinput_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class CustomiseQI extends StatefulWidget {
  @override
  _CustomiseQIState createState() => _CustomiseQIState();
}

class _CustomiseQIState extends State<CustomiseQI> {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final _formKey = GlobalKey<FormState>();
  final QuickInputDatabaseService _authQuickInput = QuickInputDatabaseService();
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
  final _allCategories = CategoryDatabaseService()
      .getAllCategories()
      .map(
          (category) =>
          MultiSelectItem<Category>(category, category.categoryName))
      .toList();
  List<Category> selectedCategories;
  String firstSelectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColour,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Select Your Top 3 Categories!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23.0,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: kDeepOrange,
                  ),
                ),
                SizedBox(height: 20.0),
                getField(),
                SizedBox(height: 100.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () async {
                              editQuickInput();
                              if (_formKey.currentState.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Succesfully Edited Your Categories!",
                                        style: TextStyle(fontFamily: 'Lato'),
                                      ),
                                      content: Text(
                                        "Would you like to edit again?",
                                        style:
                                        TextStyle(fontFamily: 'Lato.Thin'),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("Back to homepage"),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePageScreen()));
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Reedit Discussion"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Text('Submit'),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(kDeepOrangeLight),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePageScreen()));
                            },
                            child: Text('Return To Homepage'),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // this way very ugly though
  Widget getFirstStreamBuilder() {
    return StreamBuilder(
        stream: categoryCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DropdownMenuItem> categoryItems = [];
            for (DocumentSnapshot snap in snapshot.data.docs) {
              categoryItems.add(
                DropdownMenuItem(
                  child: Text(
                    snap['categoryName'],
                    style: TextStyle(color: Color(0xff11b719)),
                  ),
                  value: "${snap.id}",
                ),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                SizedBox(width: 50.0),
                DropdownButton(
                  items: categoryItems,
                  onChanged: (category) {
                    setState(() {
                      firstSelectedCategory = category;
                    });
                  },
                  value: firstSelectedCategory,
                  isExpanded: false,
                  hint: Text(
                    "Choose Your Category",
                    style: TextStyle(color: Color(0xff11b719)),
                  ),
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        });
  }

  void editFirstQuickInput() {
    categoryCollection.doc(firstSelectedCategory).get().then((value) {
      String categoryName = value['categoryName'];
      int categoryColorValue = value['categoryColorValue'];
      int categoryIconCodePoint = value['categoryIconCodePoint'];
      Category category = Category(
        categoryName: categoryName,
        categoryColor: Color(categoryColorValue),
        categoryIcon:
        Icon(IconData(categoryIconCodePoint, fontFamily: 'MaterialIcons')),
        categoryId: firstSelectedCategory,
      );
      _authQuickInput.updateQuickInput(category, firstSelectedCategory, 0);
    });
  }

  Widget getField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Colors.blue,
            width: 2,
          ),
        ),
        child: MultiSelectDialogField(
          chipDisplay: MultiSelectChipDisplay(
            icon: Icon(Icons.cancel),
            items: _allCategories,
            onTap: (value) {
              setState(() {
                selectedCategories.remove(value);
              });
            }
          ),
          backgroundColor: Colors.grey,
          searchable: true,
          items: _allCategories,
          title: Text("Categories"),
          selectedColor: Colors.blue,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8)),
            border: Border.all(
              color: Colors.blue,
              width: 2,
            ),
          ),
          buttonIcon: Icon(
            Icons.category,
            color: Colors.white,
          ),
          buttonText: Text(
            "Select Your Categories",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          onConfirm: (categories) {
            selectedCategories = categories;
          }
        ),
      ),
    );
  }

  void editQuickInput() {
    for (int i = 0; i < 3; i++) {
      Category category = selectedCategories[i];
      String categoryId = category.categoryId;
      _authQuickInput.updateQuickInput(category, categoryId, i);
    }
  }
}