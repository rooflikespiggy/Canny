import 'package:Canny/Screens/Help%20Center/help_category_screen.dart';
import 'package:Canny/Screens/Help%20Center/help_dashboard_screen.dart';
import 'package:Canny/Screens/Help%20Center/help_forum_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'help_quickinput_screen.dart';
import 'help_receipt_screen.dart';

class HelpTile extends StatefulWidget {
  final String name;
  final Icon icon;

  HelpTile({
    this.name,
    this.icon
  });

  @override
  _HelpTileState createState() => _HelpTileState();
}

class _HelpTileState extends State<HelpTile> {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(20,10,20,10),
        title: Text(
          widget.name,
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 18,
            color: Colors.blueGrey[900],
          ),
        ),
        leading: widget.icon,
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          if (widget.name == 'Quick Input') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HelpQuickInputScreen()));
          } else if (widget.name == 'Dashboard') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HelpDashboardScreen()));
          } else if (widget.name == 'Receipt') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HelpReceiptScreen()));
          } else if (widget.name == 'Categories') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HelpCategoryScreen()));
          } else if (widget.name == 'Forum') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HelpForumScreen()));
          }
        },
      ),
    );
  }
}