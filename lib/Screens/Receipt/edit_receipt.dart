import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Insert%20Function/select_category_screen.dart';
import 'package:Canny/Services/Receipt/receipt_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Shared/input_formatters.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Canny/Database/all_database.dart';
import 'package:flutter/services.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class EditReceipt extends StatefulWidget {
  static final String id = 'add_spending_screen';
  final String categoryId;
  final double cost;
  final String itemName;
  final Timestamp datetime;
  final String receiptId;

  EditReceipt({
    this.categoryId,
    this.cost,
    this.itemName,
    this.datetime,
    this.receiptId,
  });

  @override
  _EditReceiptState createState() => _EditReceiptState();
}

class _EditReceiptState extends State<EditReceipt> {

  String uid = FirebaseAuth.instance.currentUser.uid;
  final _formKey = GlobalKey<FormState>();
  final ReceiptDatabaseService _authReceipt = ReceiptDatabaseService();
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final CollectionReference expenseCollection = Database().expensesDatabase();
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  String newCategoryName;
  String categoryName;
  String newCategoryId;
  int newCategoryColorValue;
  int categoryColorValue;
  int newCategoryIconCodePoint;
  int categoryIconCodePoint;
  String newCategoryFontFamily;
  String categoryFontFamily;
  bool newIsIncome;
  bool isIncome;
  //String categoryFontPackage;
  bool changed = false;
  bool categoryChanged = false;
  bool itemNameChanged = false;
  bool dateChanged = false;
  bool costChanged = false;
  final format = DateFormat('d/M/y');
  DateTime current;

  @override
  void dispose() {
    itemNameController.dispose();
    costController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    itemNameController.text = widget.itemName;
    costController.text = widget.cost.abs().toStringAsFixed(2);
    return super.initState();
  }

  void categoryChange() {
    setState(() {
      categoryChanged = true;
    });
  }

  void dateChange() {
    setState(() {
      dateChanged = true;
    });
  }

  void costChange() {
    setState(() {
      costChanged = true;
    });
  }

  void itemNameChange() {
    setState(() {
      itemNameChanged = true;
    });
  }

  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authCategory.getCategories(),
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        if (snapshot.hasData) {
          List<Category> allCategories = snapshot.data;
          for (Category category in allCategories) {
            if (category.categoryId == widget.categoryId) {
              categoryName = category.categoryName;
              categoryColorValue = category.categoryColor.value;
              categoryIconCodePoint = category.categoryIcon.icon.codePoint;
              categoryFontFamily = category.categoryIcon.icon.fontFamily;
              isIncome = category.isIncome;
            }
          }
          return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget> [
                        Container(
                          decoration: BoxDecoration(
                            color: kLightBlue,
                            borderRadius:
                            BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                              children: <Widget> [
                                SizedBox(width: 20.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget> [
                                    SizedBox(width: 30.0),
                                    Text('Edit Receipt',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Lato",
                                          color: kDarkBlue
                                      ),
                                    ),
                                    Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.clear),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                        children: <Widget> [
                                          _showTextFormFields(itemNameController,
                                            "Edit name of expense",
                                            Icon(Icons.drive_file_rename_outline),
                                            390.0
                                          ),
                                          SizedBox(height: 15),
                                          // getMultiSelectChipField(),
                                          _showCalFormFields(costController,
                                            "Edit cost of expense",
                                            Icon(Icons.drive_file_rename_outline),
                                            390.0
                                          ),
                                          SizedBox(height: 15,),
                                          Row(
                                            children: <Widget> [
                                              SizedBox(width: 50),
                                              CircleAvatar(
                                                backgroundColor: newCategoryColorValue != null
                                                    ? Color(newCategoryColorValue).withOpacity(0.1)
                                                    : Color(categoryColorValue).withOpacity(0.1),
                                                radius: 33,
                                                child: newCategoryColorValue != null
                                                    ?  IconTheme(
                                                    data: IconThemeData(color: Color(newCategoryColorValue).withOpacity(1), size: 25),
                                                    child: Icon(IconData(newCategoryIconCodePoint,
                                                        fontFamily: newCategoryFontFamily)
                                                    ))
                                                    : IconTheme(
                                                    data: IconThemeData(color: Color(categoryColorValue).withOpacity(1), size: 25),
                                                    child: Icon(IconData(categoryIconCodePoint,
                                                        fontFamily: categoryFontFamily)
                                                    )),
                                              ),
                                              SizedBox(width: 20),
                                              GestureDetector(
                                                onTap: () async {
                                                  final Map<String, dynamic> result = await Navigator.push(context,
                                                      MaterialPageRoute(builder: (context) => SelectCategoryScreen()));
                                                  //print(result);
                                                  setState(() {
                                                    changed = true;
                                                    newCategoryId = result['categoryId'];
                                                    newCategoryName = result['categoryName'];
                                                    newCategoryIconCodePoint = result['categoryIconCodePoint'];
                                                    newCategoryFontFamily = result['categoryFontFamily'];
                                                    //categoryFontPackage = result['categoryFontPackage'];
                                                    newCategoryColorValue = result['categoryColorValue'];
                                                    newIsIncome = result['isIncome'];
                                                  });
                                                },
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Tap to Edit category of Expense',
                                                      style: TextStyle(
                                                        color: Colors.blueGrey[300],
                                                        fontSize: 16.0,
                                                        fontStyle: FontStyle.italic,
                                                      ),
                                                    ),
                                                    SizedBox(height: 3,),
                                                    Text(
                                                      changed && newCategoryName != null
                                                          ? newCategoryName
                                                          : categoryName,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20.0,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Divider(
                                            thickness: 0.7,
                                            color: Colors.grey[600],
                                            indent: 56,
                                            endIndent: 56,
                                          ),
                                          SizedBox(
                                            height: 60,
                                            width: 300,
                                            child: DateTimeField(
                                              format: format,
                                              decoration: InputDecoration(
                                                labelText: "Edit date of Expense",
                                                labelStyle: TextStyle(
                                                  fontSize: 17,
                                                  fontStyle: FontStyle.italic
                                                ),
                                                prefixIcon: Icon(Icons.calendar_today),

                                              ),
                                              initialValue: DateTime.fromMicrosecondsSinceEpoch(widget.datetime.microsecondsSinceEpoch),
                                              onShowPicker: (context, currentValue) async {
                                                var date = await showDatePicker(
                                                  context: context,
                                                  firstDate: DateTime(DateTime.now().year, DateTime.now().month - 3),
                                                  initialDate: currentValue ?? DateTime.now(),
                                                  lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3),
                                                );
                                                if (date != null) {
                                                  current = date;
                                                  dateChange();
                                                }
                                                return date;
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          TextButton(
                                            onPressed: () async {
                                              if (_formKey.currentState.validate()) {
                                                if (itemNameChanged) {
                                                  _authReceipt.updateItemName(widget.receiptId, itemNameController.text);
                                                }
                                                if (dateChanged) {
                                                  _authReceipt.updateDate(widget.receiptId,
                                                    widget.datetime,
                                                    current,
                                                    widget.categoryId,
                                                    widget.cost);
                                                }
                                                if (costChanged && newCategoryId != null && newCategoryId != widget.categoryId) {
                                                  _authReceipt.updateCostAndCategory(widget.receiptId,
                                                      widget.categoryId,
                                                      newCategoryId,
                                                      widget.datetime,
                                                      widget.cost,
                                                      newIsIncome
                                                          ? double.parse(costController.text)
                                                          : -(double.parse(costController.text)));
                                                } else if (costChanged && (newCategoryId == null || newCategoryId == widget.categoryId)) {
                                                  _authReceipt.updateCost(widget.receiptId,
                                                      widget.categoryId,
                                                      widget.datetime,
                                                      widget.cost,
                                                      isIncome
                                                          ? double.parse(costController.text)
                                                          : -(double.parse(costController.text)));
                                                } else if (!costChanged && newCategoryId != null && newCategoryId != widget.categoryId) {
                                                  _authReceipt.updateCostAndCategory(widget.receiptId,
                                                      widget.categoryId,
                                                      newCategoryId,
                                                      widget.datetime,
                                                      widget.cost,
                                                      newIsIncome
                                                          ? double.parse(costController.text)
                                                          : -(double.parse(costController.text)));
                                                }
                                                FocusScope.of(context).unfocus();
                                                Navigator.pop(context);
                                                Flushbar(
                                                  message: "Receipt successfully edited.",
                                                  icon: Icon(
                                                    Icons.check,
                                                    size: 28.0,
                                                    color: kLightBlueDark,
                                                  ),
                                                  duration: Duration(seconds: 3),
                                                  leftBarIndicatorColor: kLightBlueDark,
                                                )..show(context);
                                                itemNameController.clear();
                                                costController.clear();
                                                /*
                                                await _authReceipt.updateReceipt(widget.receiptId,
                                                    widget.categoryId,
                                                    newCategoryId,
                                                    itemNameController.text,
                                                    DateTime.now(),
                                                    newIsIncome
                                                        ? double.parse(costController.text)
                                                        : -(double.parse(costController.text)));

                                                 */
                                              }
                                              setState(() {});
                                            },
                                            child: Text('Submit',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            style: TextButton.styleFrom(
                                              backgroundColor: kDarkBlue,
                                              minimumSize: Size(350, 40),
                                            ),
                                          ),
                                          SizedBox(height: 20.0),
                                        ]
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        )
                      ]
                  )
              )
          );
        }
        return SingleChildScrollView();
      }
    );
  }

  Widget _showTextFormFields(TextEditingController text,
      String label,
      Icon icon,
      double size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: size,
        child: TextFormField(
          keyboardType: TextInputType.text,
          controller: text,
          onChanged: (val) {
            itemNameChange();
          },
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

  Widget _showCalFormFields(TextEditingController text,
      String label,
      Icon icon,
      double size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: size,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: text,
          onChanged: (val) {
            costChange();
          },
          inputFormatters: [
            DecimalTextInputFormatter(decimalRange: 2),
            //DecimalPointTextInputFormatter(),
            LengthLimitingTextInputFormatter(8),
          ],
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
            } if (roundDouble(double.parse(value), 2) == 0.00) {
              return 'Cost cannot be 0. Enter a valid expense amount.';
            } if (roundDouble(double.parse(value), 2) < 0) {
              return 'Cost cannot be a negative number. Enter a valid expense amount.';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ),
    );
  }
}