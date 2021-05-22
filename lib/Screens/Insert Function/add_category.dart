import 'package:flutter/material.dart';

class AddCategoryScreen extends StatefulWidget {
  static final String id = 'add_category_screen';

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
        titleTextStyle: TextStyle(fontFamily: 'Lato'),
      ),
      backgroundColor: Colors.brown[50],
      body: Center(
        child: Text('Add Targeted Expenditure'),
      ),
    );
  }
}