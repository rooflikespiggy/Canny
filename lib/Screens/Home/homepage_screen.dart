import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Models/expense.dart';
import 'package:Canny/Screens/Dashboard/dashboard_screen.dart';
import 'package:Canny/Screens/Forum/forum_screen.dart';
import 'package:Canny/Screens/Insert Function/add_category.dart';
import 'package:Canny/Screens/Insert%20Function/add_spending.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:Canny/Screens/Insert Function/add_targeted_expenditure.dart';
import 'package:Canny/Screens/Receipt/receipt_screen.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Services/Receipt/receipt_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calculator/flutter_calculator.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/horizontal_scrollbar.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class HomePageScreen extends StatefulWidget {
  static final String id = 'homepage_screen';

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedTab = 0;
  String uid = FirebaseAuth.instance.currentUser.uid;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final ReceiptDatabaseService _authReceipt = ReceiptDatabaseService();
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
  List<MultiSelectItem<Category>> _allCategories = [];
  List<Category> selectedCategory = [];
  // String _title = 'CANNY';


  @override
  Widget build(BuildContext context) {

    List<Widget> _pageOptions = [
      DashboardScreen(),
      ReceiptScreen(),
      ForumScreen(),
    ];

    List<BottomNavigationBarItem> _items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.view_list),
        label: 'Receipt',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.forum),
        label: 'Forum',
      ),
      /*
    BottomNavigationBarItem(
      icon: Icon(Icons.leaderboard),
      label: 'Leaderboard',
    ),
     */
    ];


    List<SpeedDialChild> _speedDailItems = [
      SpeedDialChild(
        child: Icon(
            Icons.attach_money_rounded,
          color: Colors.white,
        ),
        label: 'Add your Spendings',
        labelStyle: TextStyle(
            fontSize: 18,
          fontFamily: "Lato",
          color: kDarkBlue,
        ),
        backgroundColor: kDarkBlue,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddSpendingScreen()));
          /*
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              enableDrag: true,
              isScrollControlled: true,
              elevation: 5,
              context: context,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(8.0),
                  child: addSpendingSheet(context)
                );
              }
          );
           */
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.star,
          color: Colors.white,
        ),
        label: 'Enter your Target Expenditure',
        labelStyle: TextStyle(
          fontSize: 18,
          fontFamily: "Lato",
          color: kBlue,
        ),
        backgroundColor: kBlue,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTEScreen()));
          // print('Add Target Expenditure');
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.category,
          color: Colors.white,
        ),
        label: 'Add a new Category',
        labelStyle: TextStyle(
          fontSize: 18,
          fontFamily: "Lato",
          color: kPalePurple,
        ),
        backgroundColor: kPalePurple,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddCategoryScreen()));
          // print('Add Target Category');
        },
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pageOptions[_selectedTab],
      bottomNavigationBar: Container(
        color: kDarkBlue,
        child: Padding(
          padding: EdgeInsets.only(right: 80),
          child: BottomNavigationBar(
            backgroundColor: kDarkBlue,
            elevation: 0,
            currentIndex: _selectedTab,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: kBlue,
            selectedItemColor: kLightBlue,
            selectedLabelStyle: TextStyle(fontFamily: 'Lato'),
            unselectedLabelStyle: TextStyle(fontFamily: 'Lato'),
            onTap: (int index) {
              setState(() {
                _selectedTab = index;
              });
            },
            items: _items,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SpeedDial(
        elevation: 7,
        marginBottom: 30,
        icon: Icons.menu,
        activeBackgroundColor: kLightBlueDark,
        activeIcon: Icons.clear,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        backgroundColor: kBlue,
        shape: CircleBorder(),
        buttonSize: 70.0,
        childMarginTop: 15.0,
        childMarginBottom: 15.0,
        children: _speedDailItems
      ),
    );
  }

  /*
  Widget addSpendingSheet(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
              children: <Widget> [
                ListTile(
                  leading: Text('Enter your Expenses'),
                  trailing: Icon(Icons.clear),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _showTextFormFields(itemNameController,
                  "Enter the name of expense",
                  Icon(Icons.drive_file_rename_outline),
                ),
                SizedBox(height: 15),
                _showCalcFormFields(
                  "Enter the cost",
                  Icon(Icons.attach_money_rounded),
                ),
                SizedBox(height: 10),
                getMultiSelectChipField(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Hero(
                        tag: 'picture',
                        child: Container(
                          width: 500.0,
                          height: 205.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'styles/images/add-comment-illustration.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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
                                        "Successfully Added Your Spending Entry!",
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
                      SizedBox(height: 20)
                    ],
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }

  Widget _showTextFormFields(TextEditingController text, String label, Icon icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
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

  void _showCalculatorDialog(BuildContext context) async {
    final result = await showCalculator(context: this.context) ?? 0.00;

    this.costController.value = this.costController.value.copyWith(
      text: result.toStringAsFixed(2),
    );
  }
   */
}
