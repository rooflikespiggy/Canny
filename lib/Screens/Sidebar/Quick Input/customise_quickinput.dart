import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Screens/Quick%20Input/quick_input.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Services/Quick%20Input/quickinput_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final CollectionReference quickInputCollection = Database().quickInputDatabase();
  List<MultiSelectItem<Category>> _allCategories;

  List<Category> selectedCategories = [];
  String firstSelectedCategory;

  @override
  Widget build(BuildContext context) {
    // TODO: i dont know but i feel that should let them choose which button to edit
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("styles/images/background.png"),
            //colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Select 3 categories for \n Quick Input',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      color: kDarkBlue,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  _categoriesSelection(),
                  //getMultiSelectDialogField(),
                  SizedBox(height: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          submitButton(),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePageScreen(selectedTab: 0)));
                              },
                              child: Text('Return To Homepage'),
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(kPalePurple),
                              ),
                          ),
                        ],
                      ),
                    ],
                    //will add an illustration
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*
  Widget getMultiSelectChipField() {
    return FutureBuilder<List<Category>>(
      future: _authCategory.getCategories(),
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        if (snapshot.hasData) {
          List<Category> allCategories = snapshot.data;
          allCategories.sort((a, b) => a.categoryId.compareTo(b.categoryId));
          _allCategories = allCategories.map((category) =>
              MultiSelectItem<Category>(category, category.categoryName)).toList();
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: MultiSelectChipField(
              items: _allCategories,
              scroll: false,
              searchable: true,
              title: Text("Select Your Categories",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              icon: Icon(Icons.check),
              headerColor: Colors.blue.withOpacity(0.5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[700], width: 1.8),
              ),
              selectedChipColor: Colors.blue.withOpacity(0.5),
              selectedTextStyle: TextStyle(color: Colors.blue[800]),
              onTap: (categories) {
                categories.length > 3
                    ? categories.removeAt(0)
                    : categories;
                selectedCategories = categories;
              },
            ),
          );
        }
        return CircularProgressIndicator();
      }
    );
  }
  */

  Widget getMultiSelectDialogField() {
    return FutureBuilder<List<Category>>(
      future: _authCategory.getCategories(),
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        if (snapshot.hasData) {
          List<Category> allCategories = snapshot.data;
          allCategories.sort((a, b) => a.categoryId.compareTo(b.categoryId));
          _allCategories = allCategories.map((category) =>
              MultiSelectItem<Category>(category, category.categoryName)).toList();
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget> [
                MultiSelectDialogField(
                    backgroundColor: kLightBlue,
                    searchable: true,
                    items: _allCategories,
                    title: Text("Categories"),
                    selectedColor: kBlue,
                    decoration: BoxDecoration(
                      color: kBlue,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      border: Border.all(
                        color: kBlue,
                        width: 2,
                      ),
                    ),
                    buttonIcon: Icon(
                      Icons.arrow_downward_outlined,
                      color: Colors.white,
                    ),
                    buttonText: Text(
                      "Select Your Categories",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onSelectionChanged: (categories) {
                      categories.length > 3
                          ? categories.removeAt(0)
                          : categories;
                    },
                    onConfirm: (categories) {
                      selectedCategories = categories;
                    }
                ),
              ],
            ),
          );
        }
        return SizedBox();
      }
    );
  }

  Widget submitButton() {
    return StreamBuilder(
      stream: quickInputCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ElevatedButton(
              onPressed: () async {
                // if selected less than 3, ask them select 3
                if (selectedCategories == null || selectedCategories.length < 3) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: kLightBlue,
                          title: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Please select 3 categories",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Lato.Thin'
                              ),
                            ),
                          ),
                          actions: <Widget> [
                            SizedBox(
                              width: 130,
                              child: TextButton(
                                  child: Text("OK",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: kDarkBlue,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }
                              ),
                            ),
                            SizedBox(width: 58,)
                          ],
                        );
                      }
                  );
                } else {
                  _authQuickInput.updateQuickInput(selectedCategories[0], snapshot.data.docs[0].id);
                  _authQuickInput.updateQuickInput(selectedCategories[1], snapshot.data.docs[1].id);
                  _authQuickInput.updateQuickInput(selectedCategories[2], snapshot.data.docs[2].id);
                  if (_formKey.currentState.validate()) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "You have successfully edited Your Categories!",
                            style: TextStyle(fontFamily: 'Lato'),
                          ),
                          content: Text(
                            "Would you like to edit again?",
                            style:
                            TextStyle(fontFamily: 'Lato.Thin'),
                          ),
                          backgroundColor: kLightBlue,
                          actions: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    width: 250,
                                    child: TextButton(
                                      child: Text("ReEdit categories",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: kDarkBlue,
                                      ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),),
                                  SizedBox(
                                    width: 250,
                                    child: TextButton(
                                      child: Text("Back to homepage",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: kDarkBlue,
                                      ),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => HomePageScreen(selectedTab: 0)));
                                    },
                                  ),),
                                  SizedBox(
                                    width: 250,
                                    child: TextButton(
                                      child: Text("Check quick input",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: kDarkBlue,
                                      ),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => QuickInput()));
                                    },
                                  ),),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: Text('Submit'),
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(kDarkBlue),
              )
          );
        } return CircularProgressIndicator();
      }
    );
  }

  Widget _getCategoriesChips() {
    return selectedCategories.isEmpty
        ? Text(
      "Tap to select Categories for Quick Input",
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
    )
        : Wrap(
      spacing: 5,
      children: selectedCategories
          .map(
            (ctg) => InputChip(
          label: Text(ctg.categoryName),
          backgroundColor: ctg.categoryColor.withOpacity(0.6),
          onDeleted: () {
            setState(() {
              selectedCategories.remove(ctg);
            });
          },
        ),
      ).toList(),
    );
  }

  Widget _categoriesSelection() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        color: Colors.white.withOpacity(0.9),
        child: FutureBuilder<List<Category>>(
            future: _authCategory.getCategories(),
            builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
              if (snapshot.hasData) {
                List<Category> allCategories = snapshot.data;
                allCategories.sort((a, b) => a.categoryId.compareTo(b.categoryId));
                return GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            "Categories chosen:",
                            style: TextStyle(fontSize: 18,
                                color: kDarkBlue,
                                fontFamily: "Lato"
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        _getCategoriesChips(),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          List<Category> tempCtgs = selectedCategories;
                          return AlertDialog(
                            backgroundColor: kLightBlue,
                            actions: <Widget>[
                              SizedBox(
                                width: 130,
                                child: TextButton(
                                  child: Text("CANCEL",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: kDarkBlue,
                                  ),
                                  onPressed: () {
                                    selectedCategories = [];
                                    Navigator.pop(context);
                                  },
                                ),),
                              SizedBox(
                                width: 130,
                                child: TextButton(
                                  child: Text("APPLY",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: kDarkBlue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedCategories = List.of(tempCtgs);
                                    });
                                    Navigator.pop(context);
                                  },
                                ),),
                              SizedBox(width: 15,)
                            ],
                            title: Text("Select Categories",
                              style: TextStyle(
                                  color: kDarkBlue,
                                  fontFamily: "Lato"
                              ),
                            ),
                            content: StatefulBuilder(
                              builder: (context, setState) {
                                return Wrap(
                                    spacing: 5,
                                    children: allCategories
                                        .map(
                                          (ctg) => InputChip(
                                          label: Text(ctg.categoryName),
                                          backgroundColor: tempCtgs.contains(ctg)
                                              ? ctg.categoryColor.withOpacity(0.6)
                                              : Colors.grey[300],
                                          onSelected: (value) {
                                            setState(() {
                                              print(tempCtgs);
                                              if (!tempCtgs.contains(ctg) && tempCtgs.length < 3) {
                                                tempCtgs.add(ctg);
                                              } else if (!tempCtgs.contains(ctg) && tempCtgs.length == 3) {
                                                tempCtgs.removeAt(0);
                                                tempCtgs.add(ctg);
                                              } else {
                                                tempCtgs.remove(ctg);
                                              }
                                              tempCtgs.sort((a, b) => a.categoryId.compareTo(b.categoryId));
                                            });
                                          }),
                                    ).toList());
                              },
                            ),
                          );
                        });
                  },
                );
              }
              return SizedBox();
            }
        ),
      ),
    );
  }
}