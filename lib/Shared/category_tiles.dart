import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;
  final FaIcon categoryIcon;

  CategoryTile({
    Key key,
    this.categoryName,
    this.categoryColor,
    this.categoryIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        title: Text(
          categoryName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[900],
          ),
        ),
        leading: CircleAvatar(
            backgroundColor: Colors.deepOrange[50],
            radius: 30,
            child: IconTheme(
              data: IconThemeData(color: categoryColor, size: 25),
              child: categoryIcon),
          )
      ),
    );
  }
}
