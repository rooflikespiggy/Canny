import 'package:flutter/material.dart';

class AddTEScreen extends StatefulWidget {
  static final String id = 'add_te_screen';

  @override
  _AddTEScreenState createState() => _AddTEScreenState();
}

class _AddTEScreenState extends State<AddTEScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Targeted Expenditure"),
        titleTextStyle: TextStyle(fontFamily: 'Lato'),
      ),
      backgroundColor: Colors.brown[50],
      body: Center(
        child: Text('Add Targeted Expenditure'),
      ),
    );
  }
}