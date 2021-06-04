import 'package:Canny/Models/category.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Shared/colors.dart';
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
  Category selectedCategory;

  @override
  Widget build(BuildContext context) {
    _authCategory.initNewCategories();

    return Card(
      elevation: 3,
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
        subtitle: Text(
          DateFormat.yMMMd().format(widget.dateTime),
        ),
        leading: _getCircleAvatar(),
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
                widget.cost.toString(),
                style: TextStyle(
                  fontSize: 18,
                  color: widget.cost < 0
                      ? Colors.redAccent
                      : Colors.green,
                ),
              ),
              // maybe can change this to onTap for the whole ListTile
              // so that the text can be right at the back
              /*
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                },
              ),
               */
            ],
          ),
        ),
        onTap: () {
          // TODO: edit everything
        },
        onLongPress: () {
          // TODO: delete the expenses
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
