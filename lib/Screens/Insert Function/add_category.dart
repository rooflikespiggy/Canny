import 'package:Canny/Shared/colors.dart';
import 'package:another_flushbar/flushbar.dart';
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

class AddCategoryScreen extends StatefulWidget {
  static final String id = 'add_category_screen';

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {

  String uid = FirebaseAuth.instance.currentUser.uid;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController categoryNameController = TextEditingController();
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
  final String monthYear = DateFormat('MMM y').format(DateTime.now());
  IconTheme _icon = IconTheme(
      data: IconThemeData(color: Color(0xff443a49)),
      child: Icon(FontAwesomeIcons.question));
  String categoryId = '00';
  bool isIncome = false;

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    _icon = IconTheme(
        data: IconThemeData(color: pickerColor),
        child: _icon.child);
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
    setState((){});
    debugPrint('Picked Icon:  $icon');
  }

  void changeIsIncome() {
    setState(() => isIncome = !isIncome);
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
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
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
                                      Text('Add Category',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Lato",
                                          color: kDarkBlue
                                        ),
                                      ),
                                      Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          _icon = null;
                                          pickerColor = Color(0xff443a49);
                                          currentColor = Color(0xff443a49);
                                          categoryNameController.clear();
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
                                                    Text('Pick a Category Color',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600]
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text('Pick a Category Icon',
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
                                                                title: Text('Color your category'),
                                                                content: SingleChildScrollView(
                                                                  child: BlockPicker(
                                                                    pickerColor: currentColor,
                                                                    onColorChanged: changeColor,
                                                                  ),
                                                                ),
                                                                actions: <Widget> [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(bottom: 10.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: <Widget> [
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
                                                                      ],
                                                                    ),
                                                                  )
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
                                                  child: Text('This category is an',
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
                                                    },
                                                  )
                                              ),
                                              SizedBox(height: 10.0),
                                              TextButton(
                                                onPressed: () {
                                                  final Category category = Category(
                                                    categoryName: categoryNameController.text,
                                                    categoryColor: currentColor,
                                                    categoryIcon: _icon.child,
                                                    categoryId: categoryId,
                                                    categoryAmount: {monthYear: 0},
                                                    isIncome: isIncome,
                                                  );
                                                  if (_formKey.currentState.validate()) {
                                                    _authCategory.addNewCategory(category, category.categoryId);
                                                    FocusScope.of(context).unfocus();
                                                    Navigator.pop(context);
                                                    Flushbar(
                                                      message: "Category successfully added.",
                                                      icon: Icon(
                                                        Icons.check,
                                                        size: 28.0,
                                                        color: kLightBlueDark,
                                                      ),
                                                      duration: Duration(seconds: 3),
                                                      leftBarIndicatorColor: kLightBlueDark,
                                                    )..show(context);
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ),
    );
  }
}