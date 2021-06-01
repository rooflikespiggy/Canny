import 'package:Canny/Shared/calculator_icon_buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:Canny/Shared/calculator_buttons.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Services/Quick Input/quickinput_database.dart';

class QuickInput extends StatefulWidget {
  static final String id = 'quickinput_screen';

  @override
  QuickInputState createState() => QuickInputState();
}

class QuickInputState extends State<QuickInput> {
  String _history = '';
  String _expression = '';
  final QuickInputDatabaseService _authQuickInput = QuickInputDatabaseService();

  void numClick(String text) {
    setState(() => _expression += text);
  }

  void allClear(String text) {
    setState(() {
      _history = '';
      _expression = '';
    });
  }

  void evaluate(String text) {
    Parser p = Parser();
    Expression exp = p.parse(_expression);
    ContextModel cm = ContextModel();

    setState(() {
      _history = _expression;
      _expression = exp.evaluate(EvaluationType.REAL, cm).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[200],
        elevation: 0.0,
      ),
    //idk where that arrow on the left is from LOL
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calculator',
        home: Scaffold(
          backgroundColor: kBackgroundColour,
          body: Container(
            padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  alignment: Alignment(1.0, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      _history,
                      style: TextStyle(
                          fontSize: 24,
                          color: kDarkGrey,
                        ),
                      ),
                    ),
                  ),
                Container(
                  alignment: Alignment(1.0, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      _expression,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.blueGrey[900],
                      ),
                      ),
                    ),
                  ),
                SizedBox(height: 12),
                Row(
                  //this row of calculator buttons
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CalcButton(
                      text: 'AC',
                      fillColor: kDeepOrangePrimary,
                      callback: allClear,
                      textSize: 22,
                    ),
                    CalcIconButton(
                      icon: _authQuickInput.getSpecificQuickInput(0).categoryIcon,
                      categoryColor: _authQuickInput.getSpecificQuickInput(0).categoryColor,
                      fillColor: Colors.orange[200],
                    ),
                    CalcIconButton(
                      icon: _authQuickInput.getSpecificQuickInput(1).categoryIcon,
                      categoryColor: _authQuickInput.getSpecificQuickInput(1).categoryColor,
                      fillColor: Colors.orange[200],
                    ),
                    CalcIconButton(
                      icon: _authQuickInput.getSpecificQuickInput(2).categoryIcon,
                      categoryColor: _authQuickInput.getSpecificQuickInput(2).categoryColor,
                      fillColor: Colors.orange[200],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CalcButton(
                      text: '7',
                      fillColor: kDarkGrey,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '8',
                      fillColor: kDarkGrey,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '9',
                      fillColor: kDarkGrey,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '÷',
                      fillColor: kDeepOrangePrimary,
                      textSize: 28,
                      callback: numClick,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CalcButton(
                      text: '4',
                      fillColor: kDarkGrey,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '5',
                      fillColor: kDarkGrey,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '6',
                      fillColor: kDarkGrey,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: 'x',
                      fillColor: kDeepOrangePrimary,
                      textSize: 26,
                      callback: numClick,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CalcButton(
                      text: '1',
                      fillColor: kDarkGrey,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '2',
                      fillColor: kDarkGrey,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '3',
                      fillColor: kDarkGrey,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '-',
                      fillColor: kDeepOrangePrimary,
                      textSize: 36,
                      callback: numClick,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CalcButton(
                      text: '.',
                      fillColor: kDarkGrey,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '0',
                      fillColor: kDarkGrey,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '=',
                      fillColor: kDeepOrangePrimary,
                      callback: evaluate,
                    ),
                    CalcButton(
                      text: '+',
                      fillColor: kDeepOrangePrimary,
                      textSize: 30,
                      callback: numClick,
                    ),
                  ],
                ),
                SizedBox(
                  width: 300,
                  height: 6,
                ),
                SizedBox(
                  width: 360,
                  height: 50,
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Enter",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: kDeepOrangePrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
