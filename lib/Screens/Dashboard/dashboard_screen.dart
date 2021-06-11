import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Dashboard/indicator.dart';
import 'package:Canny/Screens/Insert%20Function/add_TE.dart';
import 'package:Canny/Screens/Sidebar/sidebar_menu.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Services/Targeted%20Expenditure/TE_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:Canny/Screens/Dashboard/expense_breakdown.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  static final String id = 'dashboard_screen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference teCollection = Database().teDatabase();
  TextEditingController teController = TextEditingController();
  TEDatabaseService _authTE = TEDatabaseService();
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
  final String monthYear = DateFormat('MMM y').format(DateTime.now());
  bool teSet;
  double teAmount = 0;
  int donutTouchedIndex;
  double totalExpensesAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        title: Text(
          "DASHBOARD",
          style: TextStyle(fontFamily: 'Lato'),
        ),
      ),
      drawer: SideBarMenu(),
      backgroundColor: kBackgroundColour,
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
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: <Widget> [
                FutureBuilder<List<Category>>(
                  future: _authCategory.getCategories(),
                  builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
                    if (snapshot.hasData) {
                      List<Category> allCategories = snapshot.data;
                      allCategories.sort((a, b) => a.categoryId.compareTo(b.categoryId));
                      totalExpensesAmount = allCategories
                          .where((category) => !category.isIncome)
                          .map((category) => category.categoryAmount[monthYear])
                          .reduce((value, element) => value + element);
                      //print(totalCategoryAmount);
                      //print(teAmount);
                      //teSet = false;
                      return StreamBuilder(
                        stream: teCollection.doc('TE').snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot2) {
                          if (snapshot2.hasData) {
                            final snapshotData = snapshot2.data;
                            teAmount = snapshot2.data['amount'];
                            return Container(
                              child: Column(
                                children: <Widget> [
                                  SizedBox(height: 10,),
                                  SizedBox(
                                    width: 360,
                                    child: TextButton(
                                        onPressed: () {
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
                                            return AddTEScreen();
                                          });
                                        },
                                        child: Text(
                                          'Monthly Targeted Expenditure: \n' + teAmount.toStringAsFixed(2),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Lato",
                                            color: kDarkBlue
                                          ),
                                        ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.white.withOpacity(0.9),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Container(
                                    width: 370,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                      color: Colors.white.withOpacity(0.9),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget> [
                                          SizedBox(height: 15.0),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget> [
                                              SizedBox(width: 15.0),
                                              Text('Expenses Breakdown',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "Lato",
                                                    color: kDarkBlue
                                                ),
                                              ),
                                            ],
                                          ),
                                          // TODO: decide where to put this total expenses
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget> [
                                              SizedBox(width: 15.0),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Total Expenses: ',
                                                  style: TextStyle(
                                                      fontFamily: "Lato",
                                                      color: Colors.black54,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: totalExpensesAmount.toStringAsFixed(2),
                                                      style: TextStyle(
                                                        fontFamily: "Lato",
                                                        color: totalExpensesAmount <= teAmount ? Colors.green : Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 270,
                                            width: 380,
                                            child: Stack(
                                              alignment: Alignment.topCenter,
                                              children: <Widget>[
                                                PieChart(
                                                  PieChartData(
                                                      pieTouchData: PieTouchData(
                                                          touchCallback: (pieTouchResponse) {
                                                            if (pieTouchResponse.touchedSection.touchedSectionIndex != null) {
                                                              setState(() {
                                                                updateDonutTouchedIndex(
                                                                    pieTouchResponse.touchedSection.touchedSectionIndex);
                                                              });
                                                            }
                                                          }),
                                                      startDegreeOffset: -90,
                                                      borderData: FlBorderData(
                                                        show: false,
                                                      ),
                                                      sectionsSpace: 2,
                                                      centerSpaceRadius: 70,
                                                      sections: showingCategorySections(
                                                          allCategories,
                                                          teAmount,
                                                          totalExpensesAmount)),
                                                  swapAnimationDuration:
                                                  Duration(seconds: 0),
                                                ),
                                                Visibility(
                                                  visible: donutTouchedIndex == null,
                                                  child: Center(
                                                    child: Text(
                                                      'Tap section for details.',
                                                      style: TextStyle(
                                                        fontStyle: FontStyle.italic,
                                                        fontSize: 10,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Wrap(
                                            direction: Axis.horizontal,
                                            alignment: WrapAlignment.center,
                                            spacing: 5.0,
                                            runSpacing: 10.0,
                                            children: showAllIndicators(allCategories),
                                          ),
                                          SizedBox(height: 20.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  StreamBuilder(
                                      stream: categoryCollection
                                          .where('isIncome', isEqualTo: false)
                                          .where('categoryAmount.$monthYear', isGreaterThan: 0)
                                          .orderBy("categoryAmount.$monthYear", descending: true)
                                          .snapshots(),
                                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if (snapshot.hasData) {
                                          return Align(
                                              alignment: Alignment.topCenter,
                                              child: ListView.builder(
                                                padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: snapshot.data.docs.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  final snapshotData = snapshot.data.docs[index];
                                                  return ExpenseBreakdown(
                                                    categoryName: snapshotData['categoryName'],
                                                    categoryColorValue: snapshotData['categoryColorValue'],
                                                    categoryIconCodePoint: snapshotData['categoryIconCodePoint'],
                                                    categoryFontFamily: snapshotData['categoryFontFamily'],
                                                    categoryFontPackage: snapshotData['categoryFontPackage'],
                                                    categoryId: snapshotData.id,
                                                    categoryAmount: snapshotData['categoryAmount'][monthYear],
                                                    categoryPercentage: totalExpensesAmount <= teAmount
                                                        ? ((snapshotData['categoryAmount'][monthYear] / teAmount) * 100)
                                                        .toStringAsFixed(0)
                                                        : ((snapshotData['categoryAmount'][monthYear] / totalExpensesAmount) * 100)
                                                        .toStringAsFixed(0)
                                                  );
                                                },
                                              )
                                          );
                                        }
                                        return CircularProgressIndicator();
                                      }
                                  ),
                                ],
                              )
                            );
                          }
                          return CircularProgressIndicator();
                        }
                      );
                    }
                    return CircularProgressIndicator();
                  }
                ),
                SizedBox(height: 50.0),
              ],
            )
          )
        )
      ),
    );
  }

  void updateDonutTouchedIndex(int i) {
    if (donutTouchedIndex == i) {
      donutTouchedIndex = null;
    } else {
      donutTouchedIndex = i;
      print(donutTouchedIndex);
    }
  }

  List<PieChartSectionData> showingCategorySections(List<Category> allCategories,
      double setAmount,
      double sumOfExpensesAmount) {
    List<Category> selectedCategories = allCategories
        .where((category) => category.categoryAmount[monthYear] > 0 && !category.isIncome)
        .toList();
    return List.generate(
      setAmount > 0 && setAmount > sumOfExpensesAmount ? selectedCategories.length + 1 : selectedCategories.length,
          (i) {
        final Category category = i < selectedCategories.length ? selectedCategories[i] : null;
        final bool isTouched = i == donutTouchedIndex;
        //final bool isIncome = i < selectedCategories.length ? category.isIncome : false;
        final double opacity = isTouched ? 1 : 0.6;
        final value = i < selectedCategories.length ? category.categoryAmount[monthYear] : setAmount - sumOfExpensesAmount;
        switch (i) {
          default:
            return PieChartSectionData(
              color: i < selectedCategories.length
                  ? category.categoryColor.withOpacity(opacity)
                  : Colors.grey[400].withOpacity(opacity),
              value: value, //isIncome ? 0 : value,
              showTitle: isTouched,
              title: i < selectedCategories.length
                  ? '${category.categoryName} \n ${value.toStringAsFixed(2)}'
                  : 'remaining',
              radius: isTouched ? 50 : 40,
              titleStyle: TextStyle(fontSize: 15, color: Colors.black87),
              titlePositionPercentageOffset: -1.5,
            );
        }
      },
    );
  }

  List<Indicator> showAllIndicators(List<Category> allCategories) {
    List<Category> selectedCategories = allCategories
        .where((category) => category.categoryAmount[monthYear] > 0 && !category.isIncome)
        .toList();
    return List.generate(
      selectedCategories.length,
      (i) {
        final Category category = selectedCategories[i];
        final bool isTouched = i == donutTouchedIndex;
        switch (i) {
          default:
            return Indicator(
              color: category.categoryColor,
              text: category.categoryName,
              isSquare: false,
              size: isTouched ? 16 : 12,
              textColor: isTouched ? Colors.black : Colors.grey,
            );
        }
      }
    );
  }
}
