import 'package:Canny/Shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
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
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.black
                                    ),
                                    child: Text('Change colour',
                                        style: TextStyle(
                                          color: Colors.white
                                        ),
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
                  child: Text('Choose a colour for new Category ',
                    style: TextStyle(
                      color: useWhiteForeground(currentColor)
                          ? const Color(0xffffffff)
                          : const Color(0xff000000),
                    ),

                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: currentColor
                  )
                ),
                SizedBox(height: 10.0),
                /*
                SizedBox(
                  width: 200,
                  height: 200,
                    child: BlockPicker(
                      pickerColor: currentColor,
                      onColorChanged: changeColor,
                    ),
                ),

                 */

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