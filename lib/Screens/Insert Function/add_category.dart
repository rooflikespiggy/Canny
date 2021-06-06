import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    _icon = IconTheme(
        data: IconThemeData(color: pickerColor),
        child: Icon(icon, size: 40)
    );
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
                child: Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget> [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Column(
                                children: <Widget> [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget> [
                                      SizedBox(width: 20.0),
                                      // TODO: make this Text nicer
                                      Text('Add A New Category'),
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
                                  // TODO: think about how to arrange the 3 buttons
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
                                              SizedBox(height: 10),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: <Widget> [
                                                      Container(
                                                        color: pickerColor,
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons.edit,
                                                              color: Colors.white),
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text('Color your category'),
                                                                  content: SingleChildScrollView(
                                                                      child: Column(
                                                                          children: <Widget>[
                                                                            BlockPicker(
                                                                              pickerColor: currentColor,
                                                                              onColorChanged: changeColor,
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                            TextButton(
                                                                                child: Text("Set as color",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                                style: TextButton.styleFrom(
                                                                                    backgroundColor: kDeepOrangeLight
                                                                                ),
                                                                                onPressed: () {
                                                                                  setState(() => currentColor = pickerColor);
                                                                                  Navigator.of(context).pop();
                                                                                }
                                                                            )
                                                                          ]
                                                                      )
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(height: 10.0),
                                                      TextButton(
                                                        child: Text('Category Icon',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        style: TextButton.styleFrom(
                                                            backgroundColor: kDeepOrangeLight
                                                        ),
                                                        onPressed: _pickIcon,
                                                      ),
                                                      SizedBox(height: 10.0),
                                                      // figure out why this wont work else change to dropdownmenu
                                                      TextButton(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            Icon(Icons.touch_app, size: 18),
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
                                                          minimumSize: Size(150, 40),
                                                          backgroundColor: isIncome
                                                              ? Colors.teal.withOpacity(0.2)
                                                              : Colors.redAccent.withOpacity(0.2),
                                                        ),
                                                        onPressed: () {
                                                          changeIsIncome();
                                                        },
                                                      )
                                                    ]
                                                ),
                                              ),
                                              SizedBox(height: 10.0),
                                              TextButton(
                                                onPressed: () async {
                                                  final Category category = Category(
                                                    categoryName: categoryNameController.text,
                                                    categoryColor: currentColor,
                                                    categoryIcon: _icon.child,
                                                    categoryId: categoryId,
                                                    categoryAmount: 0,
                                                    isIncome: isIncome,
                                                  );
                                                  if (_formKey.currentState.validate()) {
                                                    await _authCategory.addNewCategory(category, category.categoryId);
                                                    categoryNameController.clear();
                                                    pickerColor = Color(0xff443a49);
                                                    currentColor = Color(0xff443a49);
                                                    _icon = null;
                                                    Navigator.pop(context);
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
              return label;
            }
            return null;
          },
        ),
      ),
    );
  }
}