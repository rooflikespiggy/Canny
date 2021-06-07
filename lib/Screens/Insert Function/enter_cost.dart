import 'dart:math';
import 'package:Canny/Screens/Insert%20Function/add_spending.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Services/Quick%20Input/calculator_buttons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EnterCostScreen extends StatefulWidget {
  const EnterCostScreen({Key key}) : super(key: key);

  @override
  _EnterCostScreenState createState() => _EnterCostScreenState();
}

class _EnterCostScreenState extends State<EnterCostScreen> {

  String uid = FirebaseAuth.instance.currentUser.uid;
  String _history = '';
  String _expression = '';

  String getExpression() {
    return _expression;
  }

  void numClick(String text) {
    if (_expression.contains('.') && text == '.') {
      setState(() => _expression += '');
    } else {
      setState(() => _expression += text);
    }
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

  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 0.0,
      ),
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calculator',
        home: Scaffold(
          backgroundColor: kLightBlue,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 10,),
                    CalcButton(
                      text: 'AC',
                      fillColor: kDarkBlue,
                      callback: allClear,
                      textSize: 22,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CalcButton(
                      text: '7',
                      fillColor: kPalePurple,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '8',
                      fillColor: kPalePurple,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '9',
                      fillColor: kPalePurple,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '÷',
                      fillColor: kDarkBlue,
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
                      fillColor: kPalePurple,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '5',
                      fillColor: kPalePurple,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '6',
                      fillColor: kPalePurple,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: 'x',
                      fillColor: kDarkBlue,
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
                      fillColor: kPalePurple,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '2',
                      fillColor: kPalePurple,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '3',
                      fillColor: kPalePurple,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '-',
                      fillColor: kDarkBlue,
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
                      fillColor: kPalePurple,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '0',
                      fillColor: kPalePurple,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '=',
                      fillColor: kDarkBlue,
                      callback: evaluate,
                    ),
                    CalcButton(
                      text: '+',
                      fillColor: kDarkBlue,
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
                    onPressed: () {

                      Navigator.pop(context);
                    },
                    child: Text(
                      "Enter",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: kDarkBlue,
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

