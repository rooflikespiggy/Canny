import 'package:Canny/Screens/Insert%20Function/select_category_screen.dart';
import 'package:Canny/Services/Receipt/receipt_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Canny/Models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Canny/Database/all_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class AddSpendingScreen extends StatefulWidget {
  static final String id = 'add_spending_screen';

  @override
  _AddSpendingScreenState createState() => _AddSpendingScreenState();
}

class _AddSpendingScreenState extends State<AddSpendingScreen> {

  String uid = FirebaseAuth.instance.currentUser.uid;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final ReceiptDatabaseService _authReceipt = ReceiptDatabaseService();
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
  List<MultiSelectItem<Category>> _allCategories = [];
  List<Category> selectedCategory = [];
  String firstSelectedCategory;
  String categoryName = 'Others';
  String categoryId = '11';
  Icon icon;
  int categoryColorValue;
  int categoryIconCodePoint;
  String categoryFontFamily;
  //String categoryFontPackage;
  bool isIncome = false;

  @override
  Widget build(BuildContext context) {
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
                              Text('Add Your Expenses',
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
                                      "Enter the name of expense",
                                      Icon(Icons.drive_file_rename_outline),
                                      390.0,
                                    ),
                                    SizedBox(height: 15),
                                    // getMultiSelectChipField(),
                                    Row(
                                      children: <Widget> [
                                        SizedBox(width: 50),
                                        CircleAvatar(
                                          backgroundColor: categoryColorValue != null
                                              ? Color(categoryColorValue).withOpacity(0.1)
                                              : Colors.black.withOpacity(0.1),
                                          radius: 33,
                                          child: categoryColorValue != null
                                              ?  IconTheme(
                                              data: IconThemeData(color: Color(categoryColorValue).withOpacity(1), size: 25),
                                              child: Icon(IconData(categoryIconCodePoint,
                                                  fontFamily: categoryFontFamily)
                                              ))
                                              : Icon(FontAwesomeIcons.question, color: Colors.black),
                                        ),
                                        SizedBox(width: 25,),
                                        GestureDetector(
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Pick a category for this Expense',
                                                style: TextStyle(
                                                  color: Colors.blueGrey[300],
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              SizedBox(height: 3,),
                                              Text(
                                                categoryName,
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
                                    TextButton(
                                      onPressed: () {
                                        final Expense expense = Expense(
                                          categoryId: categoryId, //selectedCategory[0].categoryId,
                                          cost: isIncome //selectedCategory[0].isIncome
                                              ? double.parse(costController.text)
                                              : -(double.parse(costController.text)),
                                          itemName: itemNameController.text,
                                          uid: uid,
                                        );
                                        if (_formKey.currentState.validate()) {
                                          _authReceipt.addReceipt(expense);
                                          itemNameController.clear();
                                          costController.clear();
                                          Navigator.pop(context);
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

