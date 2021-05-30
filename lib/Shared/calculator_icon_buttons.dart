import 'package:flutter/material.dart';

class CalcIconButton extends StatelessWidget {
  final Icon icon;
  final Color fillColor;

  CalcIconButton({
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
          child: icon,
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
          color: fillColor,
        ),
      ),
    );
  }
}