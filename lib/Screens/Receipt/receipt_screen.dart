import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Sidebar/sidebar_menu.dart';
import 'package:Canny/Services/Receipt/expense_tiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Screens/Receipt/monthly_expenses.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'filter_screen.dart';

class ReceiptScreen extends StatefulWidget {
  static final String id = 'receipt_screen';

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {

  final List<Widget> monthlyExpensesList = [
    new MonthlyExpenses(year: 2021, month: 'June'),
    new MonthlyExpenses(year: 2021, month: 'July'),
    new MonthlyExpenses(year: 2021, month: 'August'),
  ];

  PageController pageController = PageController();

  final String uid = FirebaseAuth.instance.currentUser.uid;
  bool isActive = false;
  DateTime earliest = DateTime(DateTime.now().year - 1);
  DateTime latest = DateTime.now();
  List<Category> filteredCategories = [];
  final CollectionReference expensesCollection = Database().expensesDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kDarkBlue,
        title: Text(
          "RECEIPT",
          style: TextStyle(fontFamily: 'Lato'),
        ),
        actions: <Widget>[
          Visibility(
            visible: isActive,
            child: IconButton(
              icon: Icon(
                Icons.refresh,
              ),
              onPressed: () {
                setState(() {
                  earliest = DateTime(DateTime.now().year - 2);
                  latest = DateTime.now();
                  filteredCategories = <Category>[];
                  isActive = false;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.filter,
              size: 20,
              color: isActive
                  ? kDarkBlue
                  : Colors.white,
            ),
            onPressed: () async {
              final Map<String, dynamic> result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FilterScreen()));
              //print(result);
              setState(() {
                isActive = result['isActive'];
                filteredCategories = result['filteredCategories'].isNotEmpty
                    ? result['filteredCategories']
                    : <Category>[];
                earliest = result['filteredDatetime'] == null
                    ? DateTime(DateTime.now().year - 2)
                    : result['filteredDatetime'];
                latest = result['latest'] == null
                    ? DateTime.now()
                    : result['latest'];
              });
              print(filteredCategories);
            },
          ),
        ],
      ),
      drawer: SideBarMenu(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("styles/images/background-2.png"),
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                StreamBuilder(
                    stream: FilteredData(earliest: earliest,
                        latest: latest,
                        filteredCategories: filteredCategories)
                        .byDateAndCategory()
                        .orderBy('datetime')
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return Align(
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                              padding: EdgeInsets.all(4),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final snapshotData = snapshot.data.docs[index];
                                return ExpenseTile(
                                  categoryId: snapshotData['categoryId'],
                                  cost: snapshotData['cost'],
                                  itemName: snapshotData['itemName'],
                                  datetime: snapshotData['datetime'],
                                  uid: uid,
                                );
                              },
                            )
                        );
                      }
                      return CircularProgressIndicator();
                    }
                ),
                /*
                Expanded(
                  child: PageView(
                    controller: pageController,
                    children: monthlyExpensesList,
                  ),
                ),
                 */
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FilteredData {
  DateTime earliest;
  DateTime latest;
  List<Category> filteredCategories;
  final CollectionReference expensesCollection = Database().expensesDatabase();

  FilteredData({
    this.earliest,
    this.latest,
    this.filteredCategories,
  });

  Query byDate() {
    return expensesCollection
        .where('datetime', isGreaterThanOrEqualTo: earliest)
        .where('datetime', isLessThanOrEqualTo: latest);
  }

  Query byDateAndCategory() {
    if (filteredCategories.isNotEmpty) {
      return byDate()
          .where('categoryId', whereIn: filteredCategories
          .map((category) => category.categoryId)
          .toList());
    }
    return byDate();
  }


}