import 'package:flutter/material.dart';

class AddSpendingScreen extends StatefulWidget {
  static final String id = 'add_spending_screen';

  @override
  _AddSpendingScreenState createState() => _AddSpendingScreenState();
}

class _AddSpendingScreenState extends State<AddSpendingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Spending"),
        titleTextStyle: TextStyle(fontFamily: 'Lato'),
      ),
      backgroundColor: Colors.brown[50],
      body: Center(
        child: Text('Add Spending'),
      ),
    );
  }
}