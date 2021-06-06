import 'package:Canny/Models/category.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalcIconButton extends StatelessWidget {
  final Category category;
  final Color categoryColor;
  final Icon icon;
  final Color fillColor;
  final Function callback;

  CalcIconButton({
    this.category,
    this.categoryColor,
    this.icon,
    this.fillColor,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(7),
      child: SizedBox(
        width: 70,
        height: 70,
        child: MaterialButton(
          onPressed: () {
            print(category);
            callback(category);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(category.categoryName + ' chosen'),
              duration: Duration(seconds: 1),
            ));
          },
          child: IconTheme(
              data: IconThemeData(color: categoryColor.withOpacity(1), size: 38),
              child: icon,
          ),
          padding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          color: fillColor,
        ),
      ),
    );
  }
}