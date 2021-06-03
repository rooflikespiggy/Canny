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
  Icon _icon;
  int _categoryNo;
  String categoryId = '00';

  /*
  Future<int> countDocuments() async {
    QuerySnapshot _myDoc = await categoryCollection.get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    return _myDocCount.length;  // Count of Documents in Collection
  }

  Future noOfDocuments() async {
    _categoryNo = await countDocuments();
  }

  String get categoryId {
    noOfDocuments();
    return _categoryNo.toString();
  }
   */

  List<Category> categoriesList() {
    return _authCategory.allCategories;
  }

  String getCategoryId() {
    for (Category category in categoriesList()) {
      if (int.parse(category.categoryId) > int.parse(categoryId)) {
        categoryId = category.categoryId;
      }
    }
    return (int.parse(categoryId) + 1).toString();
  }

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  _pickIcon() async {
    IconData icon = await FlutterIconPicker.showIconPicker(context);
    _icon = Icon(icon,
      size: 40,
    );
    setState((){});
    debugPrint('Picked Icon:  $icon');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDeepOrangeLight,
        title: Text("Add Category"),
        titleTextStyle: TextStyle(fontFamily: 'Lato'),
      ),
      backgroundColor: kBackgroundColour,
      resizeToAvoidBottomInset: false,
      body: Center(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
              children: <Widget> [
                Text(
                'Add a new Category',
                  style: TextStyle(fontSize: 23.0,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: kDeepOrange,
                  )
                ),
                SizedBox(height: 20),
                _showTextFormFields(categoryNameController,
                  "Enter the name of new category",
                  Icon(Icons.drive_file_rename_outline),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 35,
                      width: 40,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: currentColor,
                            border: Border.all(color: Colors.black)
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Select a color'),
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
                        child: Text("Choose a colour for new Category",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: kDeepOrangeLight
                        ),

                      ),
                  ]
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: _icon != null
                            ? _icon
                            : Container(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                          ),
                        )
                    ),
                    SizedBox(width: 40),
                    TextButton(
                        child: Text('Choose an icon for new Category  ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: kDeepOrangeLight
                        ),
                      onPressed: _pickIcon,
                    )
                  ]
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () async {
                            final Category category = Category(
                              categoryName: categoryNameController.text,
                              categoryColor: currentColor,
                              categoryIcon: _icon,
                              categoryId: getCategoryId(),
                              categoryAmount: 0,
                            );
                            if (_formKey.currentState.validate()) {
                              await _authCategory.addNewCategory(category, category.categoryId).then((_) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Successfully Added a new Category!",
                                        style: TextStyle(fontFamily: 'Lato'),
                                      ),
                                      content: Text(
                                        "Would you like to add another Category?",
                                        style: TextStyle(fontFamily: 'Lato.Thin'),
                                      ),
                                      actions: <Widget> [
                                        TextButton(
                                          child: Text("Back to HomePage"),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => HomePageScreen()));
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Add another Category"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                categoryNameController.clear();
                              });
                            }
                          },
                          child: Text('Submit'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(kDeepOrangeLight),
                          )
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Return To Homepage'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.grey),
                          )
                      ),

                    ],
                  ),
                ),

              ]
            ),
          )
        )
      )
    );
  }

  Widget _showTextFormFields(TextEditingController text, String label, Icon icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: text,
        keyboardType: TextInputType.multiline,
        maxLines: null,
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
    );
  }
}