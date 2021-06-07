import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Models/expense.dart';
import 'package:Canny/Services/Quick%20Input/calculator_icon_buttons.dart';
import 'package:Canny/Services/Receipt/receipt_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:Canny/Services/Quick%20Input/calculator_buttons.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Services/Quick Input/quickinput_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class QuickInput extends StatefulWidget {
  static final String id = 'quickinput_screen';

  @override
  QuickInputState createState() => QuickInputState();
}

class QuickInputState extends State<QuickInput> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  String _history = '';
  String _expression = '';
  String _evaluate = '';
  final QuickInputDatabaseService _authQuickInput = QuickInputDatabaseService();
  final ReceiptDatabaseService _authReceipt = ReceiptDatabaseService();
  final CollectionReference quickInputCollection = Database().quickInputDatabase();
  Category _chosenCategory;
  bool evaluated = false;

  void catClick(Category category) {
    setState(() {
      _chosenCategory = category;
    });
  }

  void numClick(String text) {
    if (_expression.contains('.') &&
        text == '.' &&
        _expression.substring(_expression.length - 1, _expression.length) == ".") {
      setState(() => _expression += '');
    } else if (text == '*') {
      setState(() => _expression += 'x');
    } else if (text == '/') {
      setState(() => _expression += '÷');
    } else {
      setState(() => _expression += text);
    }
    if (_expression.contains('.') &&
        text == '.' &&
        _evaluate.substring(_evaluate.length - 1, _evaluate.length) == ".") {
      setState(() => _evaluate += '');
    } else {
      setState(() => _evaluate += text);
    }
  }

  void allClear(String text) {
    setState(() {
      evaluated = false;
      _history = '';
      _expression = '';
      _evaluate = '';
    });
  }

  void clear(String text) {
    setState(() {
      _evaluate = _evaluate.substring(0, _evaluate.length - 1);
      _expression = _expression.substring(0, _expression.length - 1);
    });
  }

  void evaluate(String text) {
    Parser p = Parser();
    Expression exp = p.parse(_evaluate);
    ContextModel cm = ContextModel();

    setState(() {
      evaluated = true;
      _history = _expression;
      _evaluate = exp.evaluate(EvaluationType.REAL, cm).toString();
    });
  }

  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  @override
  Widget build(BuildContext context) {
    _authQuickInput.initNewQuickInputs();
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
                      !evaluated ? _expression : _evaluate,
                      style: TextStyle(
                        fontSize: 38,
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
                      fillColor: kDarkBlue,
                      callback: allClear,
                      textSize: 22,
                    ),
                    quickInputButtons(),
                    /*
                    CalcIconButton(
                      category: _authQuickInput.getQuickInput(0),
                      icon: _authQuickInput.getQuickInput(0).categoryIcon,
                      categoryColor: _authQuickInput.getQuickInput(0).categoryColor,
                      fillColor: Colors.orange[200],
                      callback: catClick,
                    ),
                    CalcIconButton(
                      category: _authQuickInput.getQuickInput(1),
                      icon: _authQuickInput.getQuickInput(1).categoryIcon,
                      categoryColor: _authQuickInput.getQuickInput(1).categoryColor,
                      fillColor: Colors.orange[200],
                      callback: catClick,
                    ),
                    CalcIconButton(
                      category: _authQuickInput.getQuickInput(2),
                      icon: _authQuickInput.getQuickInput(2).categoryIcon,
                      categoryColor: _authQuickInput.getQuickInput(2).categoryColor,
                      fillColor: Colors.orange[200],
                      callback: catClick,
                    ),
                     */
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
                      onPressed: () async {
                        print(_chosenCategory);
                        final Expense expense = Expense(
                          categoryId: _chosenCategory.categoryId,
                          datetime: DateTime.now(),
                          cost: _chosenCategory.isIncome
                              ? roundDouble(double.parse(_evaluate), 2)
                              : -(roundDouble(double.parse(_evaluate), 2)),
                          itemName: _chosenCategory.categoryName,
                          uid: uid,
                        );
                        await _authReceipt.addReceipt(expense);
                        Flushbar(
                          message: "Expense successfully added.",
                          icon: Icon(
                            Icons.info_outline,
                            size: 28.0,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          duration: Duration(seconds: 3),
                          leftBarIndicatorColor:
                          Theme.of(context).colorScheme.secondary,
                        )..show(context);
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

  Widget quickInputButtons() {
    return Container(
      child: StreamBuilder(
          stream: quickInputCollection.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              //print(snapshot.data.docs[0]['categoryName']);
              return Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CalcIconButton(
                      category: Category(
                          categoryName: snapshot.data.docs[0]['categoryName'],
                          categoryAmount: snapshot.data.docs[0]['categoryAmount'],
                          categoryId: snapshot.data.docs[0]['categoryId'],
                          categoryIcon: Icon(
                              IconData(snapshot.data.docs[0]['categoryIconCodePoint'],
                                  fontFamily: snapshot.data.docs[0]['categoryFontFamily'],
                                  fontPackage: snapshot.data.docs[0]['categoryFontPackage'])),
                          categoryColor: Color(snapshot.data.docs[0]['categoryColorValue']),
                          isIncome: snapshot.data.docs[0]['isIncome']
                      ),
                      icon: Icon(
                          IconData(snapshot.data.docs[0]['categoryIconCodePoint'],
                              fontFamily: snapshot.data
                                  .docs[0]['categoryFontFamily'],
                              fontPackage: snapshot.data
                                  .docs[0]['categoryFontPackage'])),
                      categoryColor: Color(
                          snapshot.data.docs[0]['categoryColorValue']),
                      fillColor: Colors.deepOrange[100],
                      callback: catClick,
                    ),
                    SizedBox(width: 6.5),
                    CalcIconButton(
                      category: Category(
                          categoryName: snapshot.data.docs[1]['categoryName'],
                          categoryAmount: snapshot.data.docs[1]['categoryAmount'],
                          categoryId: snapshot.data.docs[1]['categoryId'],
                          categoryIcon: Icon(
                              IconData(snapshot.data.docs[1]['categoryIconCodePoint'],
                                  fontFamily: snapshot.data.docs[1]['categoryFontFamily'],
                                  fontPackage: snapshot.data.docs[1]['categoryFontPackage'])),
                          categoryColor: Color(snapshot.data.docs[1]['categoryColorValue']),
                          isIncome: snapshot.data.docs[2]['isIncome']
                      ),
                      icon: Icon(
                          IconData(snapshot.data.docs[1]['categoryIconCodePoint'],
                              fontFamily: snapshot.data
                                  .docs[1]['categoryFontFamily'],
                              fontPackage: snapshot.data
                                  .docs[1]['categoryFontPackage'])),
                      categoryColor: Color(
                          snapshot.data.docs[1]['categoryColorValue']),
                      fillColor: Colors.deepOrange[100],
                      callback: catClick,
                    ),
                    SizedBox(width: 6.5),
                    CalcIconButton(
                      category: Category(
                          categoryName: snapshot.data.docs[2]['categoryName'],
                          categoryAmount: snapshot.data.docs[2]['categoryAmount'],
                          categoryId: snapshot.data.docs[2]['categoryId'],
                          categoryIcon: Icon(
                              IconData(snapshot.data.docs[2]['categoryIconCodePoint'],
                                  fontFamily: snapshot.data.docs[2]['categoryFontFamily'],
                                  fontPackage: snapshot.data.docs[2]['categoryFontPackage'])),
                          categoryColor: Color(snapshot.data.docs[2]['categoryColorValue']),
                          isIncome: snapshot.data.docs[2]['isIncome']
                      ),
                      icon: Icon(
                          IconData(snapshot.data.docs[2]['categoryIconCodePoint'],
                              fontFamily: snapshot.data.docs[2]['categoryFontFamily'],
                              fontPackage: snapshot.data.docs[2]['categoryFontPackage'])),
                      categoryColor: Color(snapshot.data.docs[2]['categoryColorValue']),
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
