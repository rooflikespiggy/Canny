import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Receipt/edit_receipt.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Services/Receipt/receipt_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ExpenseTile extends StatefulWidget {
  final String categoryId;
  final double cost;
  final String itemName;
  final Timestamp datetime;
  final String receiptId;
  final String uid;

  ExpenseTile({
    this.categoryId,
    this.cost,
    this.itemName,
    this.datetime,
    this.receiptId,
    this.uid,
  });

  @override
  _ExpenseTileState createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile> {
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
  final ReceiptDatabaseService _authReceipt = ReceiptDatabaseService();
  Category selectedCategory;
  final SlidableController slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 1,
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
        leading:
        _getCircleAvatar(),
        /*
        CircleAvatar(
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
         */
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
        onTap: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              enableDrag: true,
              isScrollControlled: true,
              elevation: 5,
              context: context,
              builder: (BuildContext context) {
                return
                  EditReceipt(
                    categoryId: widget.categoryId,
                    cost: widget.cost,
                    itemName: widget.itemName,
                    datetime: widget.datetime,
                    receiptId: widget.receiptId,
                );
              }
          );
        },
        // TODO: I feel that should use dismissable or slidable to edit and delete but background hard
        // TODO: refer to dayspend expenses.dart
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Are you sure you want to delete this receipt?"),
                content: Text("Once it is deleted, you will not be able to retrieve it back."),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () async {
                      await _authReceipt.removeReceipt(widget.receiptId,
                          widget.categoryId,
                          widget.datetime,
                          widget.cost);
                      Navigator.pop(context);
                      Flushbar(
                        message: "Receipt Deleted.",
                        icon: Icon(
                          Icons.info_outline,
                          size: 28.0,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        duration: Duration(seconds: 3),
                        leftBarIndicatorColor:
                        Theme.of(context).colorScheme.secondary,
                      )..show(context);
                    },
                  ),
                  TextButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
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
