import 'package:Canny/Models/category.dart';
import 'package:Canny/Services/Quick%20Input/quickinput_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'calculator_icon_buttons.dart';

class QuickInputButton extends StatelessWidget {
  final QuickInputDatabaseService _authQuickInput = QuickInputDatabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _authQuickInput.getQuickInputs(),
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        if (snapshot.hasData) {
          List<Category> allQuickInputs = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                CalcIconButton(
                  icon: allQuickInputs[0].categoryIcon,
                  categoryColor: allQuickInputs[0].categoryColor,
                  fillColor: Colors.orange[200],
                ),
                SizedBox(width: 8.0),
                CalcIconButton(
                  icon: allQuickInputs[1].categoryIcon,
                  categoryColor: allQuickInputs[1].categoryColor,
                  fillColor: Colors.orange[200],
                ),
                SizedBox(width: 8.0),
                CalcIconButton(
                  icon: allQuickInputs[2].categoryIcon,
                  categoryColor: allQuickInputs[2].categoryColor,
                  fillColor: Colors.orange[200],
                ),
              ],
            ),
          );
        }
        return CircularProgressIndicator();
      }
    );
  }
}