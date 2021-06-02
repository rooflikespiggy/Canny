import 'package:Canny/Models/category.dart';
import 'package:Canny/Services/Quick%20Input/quickinput_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'calculator_icon_buttons.dart';

class QuickInputButton extends StatefulWidget {
  Category chosenCategory = new Category();

  @override
  _QuickInputButtonState createState() => _QuickInputButtonState();
}

class _QuickInputButtonState extends State<QuickInputButton> {
  final QuickInputDatabaseService _authQuickInput = QuickInputDatabaseService();

  void catClick(Category category) {
    setState(() {widget.chosenCategory = category;});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Category>>(
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
                      category: allQuickInputs[0],
                      icon: allQuickInputs[0].categoryIcon,
                      categoryColor: allQuickInputs[0].categoryColor,
                      fillColor: Colors.deepOrange[100],
                      callback: catClick,
                    ),
                    SizedBox(width: 6.9),
                    CalcIconButton(
                      category: allQuickInputs[1],
                      icon: allQuickInputs[1].categoryIcon,
                      categoryColor: allQuickInputs[1].categoryColor,
                      fillColor: Colors.deepOrange[100],
                      callback: catClick,
                    ),
                    SizedBox(width: 6.7),
                    CalcIconButton(
                      category: allQuickInputs[2],
                      icon: allQuickInputs[2].categoryIcon,
                      categoryColor: allQuickInputs[2].categoryColor,
                      fillColor: Colors.deepOrange[100],
                      callback: catClick,
                    ),
                  ],
                ),
              );
            }
            return CircularProgressIndicator();
          }
      ),
    );
  }
}


  