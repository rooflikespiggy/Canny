import 'package:Canny/Services/Category/category_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseTile extends StatefulWidget {
  String categoryId;
  double cost;
  DateTime dateTime = DateTime.now();
  String itemName;
  String uid;

  ExpenseTile({
    this.categoryId,
    this.cost,
    this.itemName,
    this.uid,
  });

  @override
  _ExpenseTileState createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile> {
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        title: Text(
          widget.itemName + "  (" + widget.cost.toString() + ")",
          style: TextStyle(
            fontSize: 18,
            color: Colors.blueGrey[900],
          ),
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.dateTime),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.deepOrange[50],
          radius: 30,
          child: IconTheme(
              data: IconThemeData(color: _authCategory
                  .getCategory(widget.categoryId).categoryColor.withOpacity(1),
                  size: 25),
              child: _authCategory
                  .getCategory(widget.categoryId)
                  .categoryIcon
          ),
        ),
        trailing:
        /*
        Row(
          children: <Widget>[
            Text(
              widget.cost.toString(),
            ),

         */
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
              },
            ),
          //],
        ),
    );
  }
}
