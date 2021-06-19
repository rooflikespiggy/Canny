import 'dart:math';

import 'package:Canny/Shared/colors.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class EditCategory extends StatefulWidget {
  static final String id = 'add_category_screen';
  final String categoryId;
  final String categoryName;
  final int categoryColorValue;
  final int categoryIconCodePoint;
  final String categoryFontFamily;
  final bool isIncome;

  EditCategory({
    this.categoryId,
    this.categoryName,
    this.categoryColorValue,
    this.categoryIconCodePoint,
    this.categoryFontFamily,
    this.isIncome,
  });

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {

  String uid = FirebaseAuth.instance.currentUser.uid;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController categoryNameController = TextEditingController();
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
  final String monthYear = DateFormat('MMM y').format(DateTime.now());
  IconTheme _icon;
  String categoryId = '00';
  bool isIncome;
  bool categoryNameChanged = false;
  bool colorChanged = false;
  bool iconChanged = false;
  bool typeChanged = false;

  // create some values
  Color pickerColor;
  Color currentColor;

  void initState() {
    categoryNameController.text = widget.categoryName;
    pickerColor = Color(widget.categoryColorValue);
    currentColor = Color(widget.categoryColorValue);
    _icon = IconTheme(
        data: IconThemeData(color: Color(widget.categoryColorValue)),
        child: Icon(IconData(widget.categoryIconCodePoint,
            fontFamily: widget.categoryFontFamily)
        ));
    isIncome = widget.isIncome;
    return super.initState();
  }

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    _icon = IconTheme(
        data: IconThemeData(color: pickerColor),
        child: _icon.child);
    colorChange();
    print(colorChanged);
  }

  _pickIcon() async {
    IconData icon = await FlutterIconPicker.showIconPicker(
        context,
        adaptiveDialog: true,
        iconPickerShape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));
    if (icon == null) {
      _icon = IconTheme(
          data: IconThemeData(color: pickerColor),
          child: Icon(FontAwesomeIcons.question)
      );
    } else {
      _icon = IconTheme(
          data: IconThemeData(color: pickerColor),
          child: Icon(icon, size: 40)
      );
    }
    iconChange();
    print(iconChanged);
    setState((){});
    debugPrint('Picked Icon:  $icon');
  }

  void changeIsIncome() {
    setState(() => isIncome = !isIncome);
  }

  void colorChange() {
    setState(() {
      colorChanged = true;
    });
  }

  void iconChange() {
    setState(() {
      iconChanged = true;
    });
  }

  void typeChange() {
    setState(() {
      typeChanged = true;
    });
  }

  void categoryNameChange() {
    setState(() {
      categoryNameChanged = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
        future: _authCategory.getCategories(),
        builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.hasData) {
            List<Category> allCategories = snapshot.data;
            allCategories.sort((a, b) => a.categoryId.compareTo(b.categoryId));
            categoryId = (int.parse(allCategories.last.categoryId) + 1).toString();
            return SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget> [
                          Container(
                            decoration: BoxDecoration(
                              color: kLightBlue,
                              borderRadius:
                              BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Column(
                                children: <Widget> [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget> [
                                      SizedBox(width: 20.0),
                                      Text('Edit Category',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Lato",
                                            color: kDarkBlue
                                        ),
                                      ),
                                      Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          Navigator.pop(context);
                                        },
                                        child: Icon(Icons.clear),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                      alignment: Alignment.topCenter,
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                            children: <Widget> [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget> [
                                                    SizedBox(width: 10.0),
                                                    CircleAvatar(
                                                      backgroundColor: pickerColor.withOpacity(0.1),
                                                      radius: 35,
                                                      child: AnimatedSwitcher(
                                                        duration: Duration(milliseconds: 300),
                                                        child: _icon,
                                                      ),
                                                    ),
                                                    _showTextFormFields(categoryNameController,
                                                      "Category Name",
                                                      Icon(Icons.drive_file_rename_outline),
                                                      240.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 7),
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(8,8,8,0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: <Widget> [
                                                      Text('Edit category color',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey[600]
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text('Edit category icon',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey[600]
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: <Widget> [
                                                      TextButton(
                                                        child: Icon(
                                                            Icons.edit,
                                                            color: Colors.white
                                                        ),
                                                        style: TextButton.styleFrom(
                                                            backgroundColor: pickerColor,
                                                            minimumSize: Size(50,50)
                                                        ),
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                  backgroundColor: kLightBlue,
                                                                title: Text('Update category color'),
                                                                content: SingleChildScrollView(
                                                                  child: BlockPicker(
                                                                    pickerColor: currentColor,
                                                                    onColorChanged: changeColor,
                                                                  ),
                                                                ),
                                                                actions: <Widget> [
                                                                  SizedBox(
                                                                    width: 130,
                                                                    child: TextButton(
                                                                      child: Text("Submit",
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                        ),
                                                                      ),
                                                                      style: TextButton.styleFrom(
                                                                        backgroundColor: kDarkBlue,
                                                                      ),
                                                                      onPressed: () {
                                                                        setState(() => currentColor = pickerColor);
                                                                        Navigator.of(context).pop();
                                                                      }
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 130,
                                                                    child: TextButton(
                                                                      child: Text("Cancel",
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
                                                                  SizedBox(width: 13.5,)
                                                                ]
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: _icon,
                                                        style: TextButton.styleFrom(
                                                            backgroundColor: pickerColor.withOpacity(0.2),
                                                            minimumSize: Size(50,50)
                                                        ),
                                                        onPressed: _pickIcon,
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              SizedBox(height: 5),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(8,8,8,0),
                                                child: Text('Edit category type',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600]
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(70,8,70,8),
                                                  child:
                                                  TextButton(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Icon(Icons.touch_app, size: 20, color: isIncome ? Colors.teal : Colors.redAccent,),
                                                        SizedBox(width: 12),
                                                        Text(isIncome ? 'INCOME' : 'EXPENSE',
                                                          style: TextStyle(
                                                              color: isIncome
                                                                  ? Colors.teal
                                                                  : Colors.redAccent
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    style: TextButton.styleFrom(
                                                      minimumSize: Size(70, 40),
                                                      backgroundColor: isIncome
                                                          ? Colors.teal.withOpacity(0.2)
                                                          : Colors.redAccent.withOpacity(0.2),
                                                    ),
                                                    onPressed: () {
                                                      changeIsIncome();
                                                      typeChange();
                                                    },
                                                  )
                                              ),
                                              SizedBox(height: 10.0),
                                              TextButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState.validate()) {
                                                    if (categoryNameChanged) {
                                                      _authCategory.updateCategoryName(widget.categoryId, categoryNameController.text);
                                                    }
                                                    if (typeChanged) {
                                                      _authCategory.updateIsIncome(widget.categoryId, isIncome);
                                                    }
                                                    if (colorChanged) {
                                                      _authCategory.updateCategoryColor(widget.categoryId, currentColor);
                                                    }
                                                    if (iconChanged) {
                                                      _authCategory.updateIcon(widget.categoryId, _icon.child);
                                                    }
                                                    Navigator.pop(context);
                                                    Flushbar(
                                                      message: "Category successfully edited.",
                                                      icon: Icon(
                                                        Icons.check,
                                                        size: 28.0,
                                                        color: kLightBlueDark,
                                                      ),
                                                      duration: Duration(seconds: 3),
                                                      leftBarIndicatorColor: kLightBlueDark,
                                                    )..show(context);
                                                    categoryNameController.clear();
                                                  }
                                                },
                                                child: Text('Submit',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: TextButton.styleFrom(
                                                  backgroundColor: kDarkBlue,
                                                  minimumSize: Size(350, 40),
                                                ),
                                              ),
                                              SizedBox(height: 20.0),
                                            ]
                                        ),
                                      )
                                  ),
                                ]
                            ),
                          )
                        ]
                    )
                )
            );
          }
          return SizedBox();
        }
    );
  }

  Widget _showTextFormFields(TextEditingController text, String label, Icon icon, double size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: size,
        child: TextFormField(
          controller: text,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: icon,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (value.isEmpty) {
              return "Enter category name";
            }
            return null;
          },
          onChanged: (val) {
            categoryNameChange();
          },
        ),
      ),
    );
  }
}