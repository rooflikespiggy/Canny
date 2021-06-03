import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Services/Receipt/receipt_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Canny/Models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Canny/Database/all_database.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Models/category.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDeepOrangeLight,
        title: Text("Add Spending"),
        titleTextStyle: TextStyle(fontFamily: 'Lato'),
      ),
      backgroundColor: kBackgroundColour,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget> [
                Text(
                  'Add an entry for spending',
                  style: TextStyle(fontSize: 23.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                  color: kDeepOrange,
                  )
                ),
                SizedBox(height: 20.0),
                _showTextFormFields(itemNameController,
                  "Enter the name of expense",
                  Icon(Icons.drive_file_rename_outline),
                ),
                SizedBox(height: 15),
                _showCalcFormFields(
                  "Enter the cost",
                   Icon(Icons.attach_money_rounded),
                ),
                SizedBox(height: 5),
                getMultiSelectDialogField(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () async {
                            final Expense expense = Expense(
                              categoryId: selectedCategory[0].categoryId,
                              cost: selectedCategory[0].isIncome
                                  ? double.parse(costController.text)
                                  : -(double.parse(costController.text)),
                              itemName: itemNameController.text,
                              uid: uid,
                            );
                            if (_formKey.currentState.validate()) {
                              await _authReceipt.addExpense(expense).then((_) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Successfully Submitted Your Spending Entry!",
                                        style: TextStyle(fontFamily: 'Lato'),
                                      ),
                                      content: Text(
                                        "Would you like to add another Spending Entry?",
                                        style: TextStyle(fontFamily: 'Lato.Thin'),
                                      ),
                                      actions: <Widget> [
                                        TextButton(
                                          child: Text("Back to HomePage"),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => HomePageScreen()));
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Add another Spending Entry"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                itemNameController.clear();
                                costController.clear();
                              });
                            }
                          },
                          child: Text('Submit'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(kDeepOrangeLight),
                          )
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Return To Homepage'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.grey),
                          )
                      ),

                    ],
                  ),
                ),
              ]
            ),
          ),
        )
      )
    );
  }

  Widget _showTextFormFields(TextEditingController text, String label, Icon icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: text,
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
          return CircularProgressIndicator();
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