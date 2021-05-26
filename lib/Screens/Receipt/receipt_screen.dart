import 'package:Canny/Screens/Sidebar/sidebar_menu.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Shared/colors.dart';

class ReceiptScreen extends StatefulWidget {
  static final String id = 'receipt_screen';

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDeepOrangePrimary,
        title: Text(
          "LEADERBOARD",
          style: TextStyle(fontFamily: 'Lato'),
        ),
      ),
      drawer: SideBarMenu(),
      backgroundColor: Colors.brown[100],
      body: Center(
        child: Text('Receipt'),
      ),
    );
  }
}