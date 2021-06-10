import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final String categoryName;
  final int categoryColorValue;
  final int categoryIconCodePoint;
  final String categoryFontFamily;
  final String categoryFontPackage;
  final String categoryId;
  final double categoryAmount;
  final double size;
  final Color textColor;


  const Indicator({
    Key key,
    this.categoryName,
    this.categoryColorValue,
    this.categoryIconCodePoint,
    this.categoryFontFamily,
    this.categoryFontPackage,
    this.categoryId,
    this.categoryAmount,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(10,10,30,10),
          title: Text(
            categoryName,
            style: TextStyle(fontSize: 18, color: textColor, fontFamily: "Lato"),
          ),
          leading: CircleAvatar(
            backgroundColor: Color(categoryColorValue).withOpacity(0.1),
            radius: 30,
            child: IconTheme(
                data: IconThemeData(color: Color(categoryColorValue).withOpacity(1), size: 25),
                child: Icon(IconData(categoryIconCodePoint,
                    fontFamily: categoryFontFamily,
                    fontPackage: categoryFontPackage)
                )
            ),
          ),
          trailing:Text(categoryAmount.toString(),
            style: TextStyle(fontSize: 16, color: textColor, fontFamily: "Lato"),
          ),
          /*
          children: <Widget>[
            SizedBox(width:15,),
            CircleAvatar(
              backgroundColor: Color(categoryColorValue).withOpacity(0.1),
              radius: 25,
              child: IconTheme(
                  data: IconThemeData(color: Color(categoryColorValue).withOpacity(1), size: 25),
                  child: Icon(IconData(categoryIconCodePoint,
                      fontFamily: categoryFontFamily,
                      fontPackage: categoryFontPackage)
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 6.0),
              child: Text(
                categoryName,
                style: TextStyle(fontSize: 16, color: textColor, fontFamily: "Lato"),
              ),
            ),
            SizedBox(width: 90,),
            Text(categoryAmount.toString(),
              style: TextStyle(fontSize: 16, color: textColor, fontFamily: "Lato"),
            )
          ],

           */
        ),
    );
  }
}