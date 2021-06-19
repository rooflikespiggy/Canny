import 'package:flutter/material.dart';

class ExpenseBreakdown extends StatelessWidget {
  final String categoryName;
  final int categoryColorValue;
  final int categoryIconCodePoint;
  final String categoryFontFamily;
  final String categoryFontPackage;
  final String categoryId;
  final double categoryAmount;
  final String categoryPercentage;
  final double size;
  final Color textColor;


  const ExpenseBreakdown({
    Key key,
    this.categoryName,
    this.categoryColorValue,
    this.categoryIconCodePoint,
    this.categoryFontFamily,
    this.categoryFontPackage,
    this.categoryId,
    this.categoryAmount,
    this.categoryPercentage,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(10, 10, 20, 10),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            categoryName,
            style: TextStyle(
                fontSize: 18,
                color: textColor,
                fontFamily: "Lato"
            ),
          ),
          Text(
            categoryPercentage + '%',
            style: TextStyle(
                fontSize: 15,
                color: textColor,
                fontFamily: "Lato"
            ),
          ),
        ],
      ),
      leading: CircleAvatar(
        backgroundColor: Color(categoryColorValue).withOpacity(0.1),
        radius: 30,
        child: IconTheme(
            data: IconThemeData(
                color: Color(categoryColorValue).withOpacity(1), size: 25),
            child: Icon(IconData(categoryIconCodePoint,
                fontFamily: categoryFontFamily,
                fontPackage: categoryFontPackage)
            )
        ),
      ),
      trailing: Text('\$' + categoryAmount.toStringAsFixed(2),
        style: TextStyle(
            fontSize: 16,
            color: textColor,
            fontFamily: "Lato"),
      ),
  }
     */
    return Card(
        color: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(10,10,20,10),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Text(
                categoryName,
                style: TextStyle(
                    fontSize: 18,
                    color: textColor,
                    fontFamily: "Lato"
                ),
              ),
              Text(
                categoryPercentage + '%',
                style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                    fontFamily: "Lato-Thin"
                ),
              ),
            ],
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
          trailing: Text('\$' + categoryAmount.toStringAsFixed(2),
            style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontFamily: "Lato-Thin"),
          ),
        ),
    );
  }
}