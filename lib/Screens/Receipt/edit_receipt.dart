import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Insert%20Function/select_category_screen.dart';
import 'package:Canny/Services/Receipt/receipt_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Shared/input_formatters.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Canny/Database/all_database.dart';
import 'package:flutter/services.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

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
              child: Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                    // TODO: make this Text nicer
                                    Text('Edit Your Receipt',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Lato",
                                          color: kDarkBlue
                                      ),
                                    ),
                                    Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        itemNameController.clear();
                                        costController.clear();
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
                                            "Edit the name of expense",
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
                                              SizedBox(width: 25),
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
                                                      'Edit category for this Expense',
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
                                                labelText: "Edit date of Expenses",
                                                prefixIcon: Icon(Icons.calendar_today),

                                              ),
                                              initialValue: DateTime.fromMicrosecondsSinceEpoch(widget.datetime.microsecondsSinceEpoch),
                                              onShowPicker: (context, currentValue) async {
                                                var date = await showDatePicker(
                                                  context: context,
                                                  firstDate: DateTime(DateTime.now().year - 5),
                                                  initialDate: currentValue ?? DateTime.now(),
                                                  lastDate: DateTime(DateTime.now().year + 5),
                                                );
                                                if (date != null) {
                                                  current = date;
                                                  dateChange();
                                                }
                                                return date;
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          TextButton(
                                            onPressed: () async {
                                              if (_formKey.currentState.validate()) {
                                                if (itemNameChanged) {
                                                  _authReceipt.updateItemName(widget.receiptId, itemNameController.text);
                                                }
                                                if (dateChanged) {
                                                  _authReceipt.updateDate(widget.receiptId, current);
                                                }
                                                if (costChanged && newCategoryId != null && newCategoryId != widget.categoryId) {
                                                  _authReceipt.updateCostAndCategory(widget.receiptId,
                                                      widget.categoryId,
                                                      newCategoryId,
                                                      widget.cost,
                                                      newIsIncome
                                                          ? double.parse(costController.text)
                                                          : -(double.parse(costController.text)));
                                                } else if (costChanged && newCategoryId == null) {
                                                  _authReceipt.updateCost(widget.receiptId,
                                                      widget.categoryId,
                                                      isIncome
                                                          ? double.parse(costController.text)
                                                          : -(double.parse(costController.text)));
                                                } else if (!costChanged && newCategoryId != null && newCategoryId != widget.categoryId) {
                                                  _authReceipt.updateCostAndCategory(widget.receiptId,
                                                      widget.categoryId,
                                                      newCategoryId,
                                                      widget.cost,
                                                      newIsIncome
                                                          ? double.parse(costController.text)
                                                          : -(double.parse(costController.text)));
                                                }
                                                itemNameController.clear();
                                                costController.clear();
                                                Navigator.pop(context);
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
            } if (value == '0' || value == '0.0' || value == '0.00') {
              return 'Cost cannot be 0. Enter a valid expense amount.';
            }
            return null;
          },
        ),
      ),
    );
  }
}