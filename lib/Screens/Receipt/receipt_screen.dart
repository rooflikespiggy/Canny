import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Sidebar/sidebar_menu.dart';
import 'package:Canny/Screens/Receipt/expense_tiles.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Shared/custom_route.dart';
import 'package:Canny/Shared/empty_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'filter_screen.dart';

class ReceiptScreen extends StatefulWidget {
  static final String id = 'receipt_screen';

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {

  PageController pageController = PageController();

  final String uid = FirebaseAuth.instance.currentUser.uid;
  bool isActive = false;
  bool reload = false;
  DateTime earliest = DateTime(DateTime.now().year - 1);
  DateTime latest;
  List<Category> filteredCategories = [];
  final CollectionReference expensesCollection = Database().expensesDatabase();
  final CollectionReference categoryCollection = Database().categoryDatabase();

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
                  latest = DateTime(DateTime.now().year + 2);
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
                  NoAnimationMaterialPageRoute(builder: (context) => FilterScreen()));
              //print(result);
              setState(() {
                isActive = result['isActive'];
                filteredCategories = result['filteredCategories'].isNotEmpty
                    ? result['filteredCategories']
                    : <Category>[];
                earliest = result['earliest'] == null
                    ? DateTime(DateTime.now().year - 2)
                    : result['earliest'];
                latest = result['latest'] == null
                    ? null
                    : result['latest'];
              });
              // print(filteredCategories);
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
                Visibility(
                  visible: isActive,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.green[200].withOpacity(0.8),
                    ),
                    child: Text(
                      "FILTER APPLIED",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                StreamBuilder(
                    stream: FilteredData(earliest: earliest,
                        latest: latest,
                        filteredCategories: filteredCategories)
                        .byDateAndCategory()
                        .orderBy('datetime', descending: true)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.isEmpty) {
                          return Column(
                            children: <Widget> [
                              SizedBox(height: 255),
                              EmptyState(
                                icon: Icon(
                                  FontAwesomeIcons.solidMeh,
                                  color: Colors.grey,
                                  size: 100.0,
                                ),
                                messageColor: Colors.grey,
                                message: 'Nothing to show here yet. \n'
                                    'Add a new receipt.',
                              ),
                            ],
                          );
                        } else {
                          return ListView.builder(
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
                                receiptId: snapshotData.id,
                                uid: uid,
                              );
                            },
                          );
                        }
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
                SizedBox(height: 50.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getData() async* {
    //await Future.delayed(const Duration(milliseconds: 300));
    yield* FilteredData(earliest: earliest,
        latest: latest,
        filteredCategories: filteredCategories)
        .byDateAndCategory()
        .orderBy('datetime', descending: true)
        .snapshots();
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
    if (latest ==  null) {
      return expensesCollection
          .where('datetime', isGreaterThanOrEqualTo: earliest);
    }
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