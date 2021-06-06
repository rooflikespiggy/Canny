import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Screens/Insert%20Function/select_category_screen.dart';
import 'package:Canny/Screens/Sidebar/View%20Categories/category_screen.dart';
import 'package:Canny/Services/Receipt/receipt_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Canny/Models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Canny/Database/all_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:flutter_calculator/flutter_calculator.dart';

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
  String categoryName = 'Food & Drinks';
  String categoryId = '00';
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
                      color: Colors.white,
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
                              Text('Add Your Expenses'),
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
                          SizedBox(height: 20),
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
                                    _showCalcFormFields(
                                      "Enter the cost",
                                      Icon(Icons.attach_money_rounded),
                                    ),
                                    // getMultiSelectChipField(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget> [
                                        CircleAvatar(
                                          backgroundColor: categoryColorValue != null
                                              ? Color(categoryColorValue).withOpacity(0.1)
                                              : Colors.black.withOpacity(0.1),
                                          radius: 30,
                                          child: categoryColorValue != null
                                              ?  IconTheme(
                                              data: IconThemeData(color: Color(categoryColorValue).withOpacity(1), size: 25),
                                              child: Icon(IconData(categoryIconCodePoint,
                                                  fontFamily: categoryFontFamily)
                                              ))
                                              : Icon(FontAwesomeIcons.question, color: Colors.black),
                                        ),
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
                                            children: <Widget>[
                                              Text(
                                                'Category',
                                                style: TextStyle(
                                                  color: Colors.blueGrey[200],
                                                  fontSize: 18.0,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                categoryName,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final Expense expense = Expense(
                                          categoryId: categoryId, //selectedCategory[0].categoryId,
                                          cost: isIncome //selectedCategory[0].isIncome
                                              ? double.parse(costController.text)
                                              : -(double.parse(costController.text)),
                                          itemName: itemNameController.text,
                                          uid: uid,
                                        );
                                        if (_formKey.currentState.validate()) {
                                          await _authReceipt.addExpense(expense);
                                          itemNameController.clear();
                                          costController.clear();
                                          Navigator.pop(context);
                                        }
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


  Widget _showCalcFormFields(String label, Icon icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        //showCursor: false,
        readOnly: true,
        controller: this.costController,
        onTap: () => this._showCalculatorDialog(context),
        keyboardType: TextInputType.multiline,
        maxLines: null,
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
    );
  }

  Widget getFirstStreamBuilder() {
    return StreamBuilder(
        stream: categoryCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DropdownMenuItem> categoryItems = [];
            for (DocumentSnapshot snap in snapshot.data.docs) {
              categoryItems.add(
                DropdownMenuItem(
                  child: Text(
                    snap['categoryName'],
                    style: TextStyle(color: Color(0xff11b719)),
                  ),
                  value: "${snap.id}",
                ),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                SizedBox(width: 50.0),
                DropdownButton(
                  items: categoryItems,
                  onChanged: (category) {
                    setState(() {
                      firstSelectedCategory = category;
                    });
                  },
                  value: firstSelectedCategory,
                  isExpanded: false,
                  hint: Text(
                    "Choose Your Category",
                    style: TextStyle(color: Color(0xff11b719)),
                  ),
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        });
  }

  Widget getMultiSelectChipField() {
    return FutureBuilder<List<Category>>(
        future: _authCategory.getCategories(),
        builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.hasData) {
            List<Category> allCategories = snapshot.data;
            allCategories.sort((a, b) => a.categoryId.compareTo(b.categoryId));
            _allCategories = allCategories.map((category) =>
                MultiSelectItem<Category>(category, category.categoryName)).toList();
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: MultiSelectChipField(
                items: _allCategories,
                //scroll: false,
                scrollBar: HorizontalScrollBar(),
                searchable: true,
                title: Text("Select Your Categories",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16,
                  ),
                ),
                icon: Icon(Icons.check),
                headerColor: Colors.blue.withOpacity(0.5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[700], width: 1.8),
                  borderRadius: BorderRadius.all(Radius.circular(7.5)),
                ),
                selectedChipColor: Colors.blue.withOpacity(0.5),
                selectedTextStyle: TextStyle(color: Colors.blue[800]),
                onTap: (categories) {
                  categories.length > 1
                      ? categories.removeAt(0)
                      : categories;
                  selectedCategory = categories;
                },
              ),
            );
          }
          return CircularProgressIndicator();
        }
    );
  }

  Widget getMultiSelectDialogField() {
    return FutureBuilder<List<Category>>(
        future: _authCategory.getCategories(),
        builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.hasData) {
            List<Category> allCategories = snapshot.data;
            allCategories.sort((a, b) => a.categoryId.compareTo(b.categoryId));
            _allCategories = allCategories.map((category) =>
                MultiSelectItem<Category>(category, category.categoryName)).toList();
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 120.0,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                child: MultiSelectDialogField(
                    backgroundColor: Colors.white,
                    searchable: true,
                    items: _allCategories,
                    title: Text("Categories"),
                    selectedColor: Colors.blue,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    buttonIcon: Icon(
                      Icons.arrow_downward_outlined,
                      color: Colors.white,
                    ),
                    buttonText: Text(
                      "Select the Category",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onSelectionChanged: (categories) {
                      categories.length > 1
                          ? categories.removeAt(0)
                          : categories;
                    },
                    onConfirm: (category) {
                      selectedCategory = category;
                    }
                ),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.all(8.0),
          );
        }
    );
  }

  void _showCalculatorDialog(BuildContext context) async {
    final result = await showCalculator(context: this.context) ?? 0.00;

    this.costController.value = this.costController.value.copyWith(
      text: result.toStringAsFixed(2),
    );
  }
}

