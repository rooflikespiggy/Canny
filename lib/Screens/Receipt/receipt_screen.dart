import 'package:flutter/material.dart';

class ReceiptScreen extends StatefulWidget {
  static final String id = 'receipt_screen';

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Center(
        child: Text('Receipt'),
      ),
    );
  }
}