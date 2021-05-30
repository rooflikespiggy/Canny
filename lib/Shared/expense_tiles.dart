import 'package:Canny/Services/Receipt/receipt_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:flutter/material.dart';

class ExpenseTile extends StatefulWidget {
  final String categoryId;
  final double cost;
  final DateTime dateTime;
  final String itemName;
  final String uid;

  ExpenseTile({
    this.categoryId,
    this.cost,
    this.dateTime,
    this.itemName,
    this.uid,
  });

  @override
  _ExpenseTileState createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        title: Text(
          widget.itemName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[900],
          ),
        ),
        subtitle: Text(
          widget.dateTime.toString(),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.deepOrange[50],
          radius: 30,
          child: IconTheme(
              data: IconThemeData(color: Color(widget.categoryId.color).withOpacity(1), size: 25),
              child: Icon(IconData(widget.categoryId.icon, fontFamily: 'MaterialIcons'))
          ),
        ),
        trailing: Row(
          children: <Widget>[
            Text(
              widget.cost.toString(),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {

              },
            ),
          ],
      ),
    );
    );
  }
}
