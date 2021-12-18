import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Receipt/edit_receipt.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Services/Receipt/receipt_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class RExpenseTile extends StatefulWidget {
  final String categoryId;
  final double cost;
  final String itemName;
  final Timestamp datetime;
  final String receiptId;
  final String uid;

  RExpenseTile({
    this.categoryId,
    this.cost,
    this.itemName,
    this.datetime,
    this.receiptId,
    this.uid,
  });

  @override
  _RExpenseTileState createState() => _RExpenseTileState();
}

class _RExpenseTileState extends State<RExpenseTile> {
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
  final ReceiptDatabaseService _authReceipt = ReceiptDatabaseService();
  final CollectionReference categoryCollection = Database().categoryDatabase();
  Category selectedCategory;
  final SlidableController slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        title: Text(
          widget.itemName,
          style: TextStyle(
            fontSize: 18,
            color: Colors.blueGrey[900],
          ),
        ),
        subtitle: Text(DateFormat("d MMMM y")
            .format(DateTime.fromMillisecondsSinceEpoch(
            widget.datetime.seconds * 1000)),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            )
        ),
        leading: _getCircleAvatar(),
        trailing: Container(
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget> [
              // see if want to put text here
              Text(
                'Amount',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blueGrey[900],
                ),
              ),
              Text(
                widget.cost.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 18,
                  color: widget.cost < 0
                      ? Colors.redAccent
                      : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCircleAvatar() {
    return FutureBuilder<List<Category>>(
        future: _authCategory.getCategories(),
        builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.hasData) {
            List<Category> allCategories = snapshot.data;
            allCategories.sort((a, b) => a.categoryId.compareTo(b.categoryId));
            for (Category category in allCategories) {
              if (category.categoryId == widget.categoryId) {
                selectedCategory = category;
              }
            }
            return CircleAvatar(
              backgroundColor: selectedCategory.categoryColor.withOpacity(0.1),
              radius: 30,
              child: IconTheme(
                  data: IconThemeData(
                      color: selectedCategory.categoryColor.withOpacity(1),
                      size: 25),
                  child: selectedCategory.categoryIcon
              ),
            );
          }
          return CircleAvatar();
        }
    );
  }
}