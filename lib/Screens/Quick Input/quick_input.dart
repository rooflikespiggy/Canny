import 'package:flutter/material.dart';

class QuickInput extends StatefulWidget {
  static final String id = 'quickinput_screen';

  @override
  _QuickInputState createState() => _QuickInputState();
}

class _QuickInputState extends State<QuickInput> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Center(
        child: MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back to function page'),
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
      ),
    );
  }
}

