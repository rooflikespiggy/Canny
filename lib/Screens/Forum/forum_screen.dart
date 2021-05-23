import 'package:flutter/material.dart';


class ForumScreen extends StatefulWidget {
  static final String id = 'forum_screen';

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Center(
        child: Text('Add Forum'),
      ),
    );
  }
}