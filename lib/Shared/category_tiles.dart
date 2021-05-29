import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final int categoryColorValue;
  final int categoryIconCodePoint;

  CategoryTile({
    this.categoryName,
    this.categoryColorValue,
    this.categoryIconCodePoint,
  });

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
              data: IconThemeData(color: Color(categoryColorValue).withOpacity(1), size: 25),
              child: FaIcon(IconData(categoryIconCodePoint, fontFamily: 'MaterialIcons'))
            ),
          )
      ),
    );
  }
}
