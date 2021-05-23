import 'package:flutter/material.dart';

class AddDiscussion extends StatefulWidget {
  static final String id = 'add_discussion';

  @override
  _AddDiscussionState createState() => _AddDiscussionState();
}

class _AddDiscussionState extends State<AddDiscussion> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Discussion"),
        titleTextStyle: TextStyle(fontFamily: 'Lato'),
      ),
      backgroundColor: Colors.brown[100],
      body: Center(
        child: Text('Add Discussion'),
      ),
    );
  }
}