import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  final String text;
  final Color fillColor;
  final Color textColor;
  final double textSize;
  final Function callback;

  const CalcButton({
    Key key,
    this.text,
    this.fillColor,
    this.textColor = Colors.white,
    this.textSize = 28,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(7),
      child: SizedBox(
        width: 70,
        height: 70,
        child: TextButton(
          onPressed: () {
            callback(text);
          },
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
              fontSize: textSize,
            )
          ),
          style: TextButton.styleFrom(
            backgroundColor: fillColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ),
    );
  }
}