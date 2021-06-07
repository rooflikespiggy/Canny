import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Models/expense.dart';
import 'package:Canny/Screens/Insert%20Function/select_category_screen.dart';
import 'package:Canny/Services/Quick%20Input/calculator_icon_buttons.dart';
import 'package:Canny/Services/Receipt/receipt_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:Canny/Services/Quick%20Input/calculator_buttons.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Services/Quick Input/quickinput_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class ExpenseCalculator extends StatefulWidget {
  static final String id = 'quickinput_screen';

  @override
  ExpenseCalculatorState createState() => ExpenseCalculatorState();
}

class ExpenseCalculatorState extends State<ExpenseCalculator> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  String _history = '';
  String _expression = '';
  String _evaluate = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController itemNameController = TextEditingController();
  final QuickInputDatabaseService _authQuickInput = QuickInputDatabaseService();
  final ReceiptDatabaseService _authReceipt = ReceiptDatabaseService();
  final CollectionReference quickInputCollection = Database().quickInputDatabase();
  String categoryName = 'Food & Drinks';
  String categoryId = '00';
  Icon icon;
  int categoryColorValue;
  int categoryIconCodePoint;
  String categoryFontFamily;
  //String categoryFontPackage;
  bool isIncome = false;
  bool evaluated = false;

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
    return Scaffold(
      backgroundColor: kLightBlue,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        title: Text('Enter your Expenses'),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 12, 10, 0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5,),
              // how to put this right at the top
              _showTextFormFields(itemNameController,
                "Enter the name of expense",
                Icon(Icons.drive_file_rename_outline),
                390.0,
              ),
              SizedBox(height: 15),

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
              SizedBox(height: 10,),
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
              SizedBox(height: 5),
              SizedBox(
                height: 70,
                child: Row(
                  //this row of calculator buttons
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CalcButton(
                      text: 'AC',
                      fillColor: kDarkBlue,
                      callback: allClear,
                      textSize: 22,
                    ),
                    CalcButton(
                      text: 'C',
                      fillColor: kDarkBlue,
                      callback: clear,
                      textSize: 22,
                    ),
                    /// add the gesture thing here
                    Container(
                      width: 180,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        color: kBlue
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          final Map<String, dynamic> result = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) => SelectCategoryScreen()));
                          //print(result);
                          setState(() {
                            categoryId = result['categoryId'];
                            categoryName = result['categoryName'];
                            isIncome = result['isIncome'];
                            categoryIconCodePoint = result['categoryIconCodePoint'];
                            categoryFontFamily = result['categoryFontFamily'];
                            //categoryFontPackage = result['categoryFontPackage'];
                            categoryColorValue = result['categoryColorValue'];
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Category',
                              style: TextStyle(
                                color: Colors.blueGrey[200],
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              categoryName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                //fontWeight: FontWeight.w100,
                                fontFamily: "Lato"
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
                child: Row(
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
              ),
              SizedBox(
                height: 70,
                child: Row(
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
              ),
              SizedBox(
                height: 70,
                child: Row(
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
              ),
              SizedBox(
                height: 70,
                child: Row(
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
              ),
              SizedBox(
                width: 300,
                height: 6,
              ),
              SizedBox(
                width: 360,
                height: 45,
                child: TextButton(
                  onPressed: () async {
                    final Expense expense = Expense(
                      categoryId: categoryId, //selectedCategory[0].categoryId,
                      cost: isIncome //selectedCategory[0].isIncome
                          ? roundDouble(double.parse(_evaluate), 2)
                          : -(roundDouble(double.parse(_evaluate), 2)),
                      itemName: itemNameController.text,
                      uid: uid,
                    );
                    if (_formKey.currentState.validate()) {
                      // TODO: need error if amount added is 0
                      await _authReceipt.addReceipt(expense);
                      itemNameController.clear();
                      Navigator.pop(context);
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
                    }
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
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
    );
  }

  Widget _showTextFormFields(TextEditingController text, String label, Icon icon, double size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: size,
        child: TextFormField(
          controller: text,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: icon,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (value.isEmpty) {
              return label;
            }
            return null;
          },
        ),
      ),
    );
  }
}