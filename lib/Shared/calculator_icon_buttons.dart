import 'package:flutter/material.dart';

class CalcIconButton extends StatelessWidget {
  final Color categoryColor;
  final Icon icon;
  final Color fillColor;

  CalcIconButton({
    this.categoryColor,
    this.icon,
    this.fillColor,
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
          },
          child: IconTheme(
              data: IconThemeData(color: categoryColor.withOpacity(1), size: 25),
              child: icon,
          ),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
          color: fillColor,
        ),
      ),
    );
  }
}