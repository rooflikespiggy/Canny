import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Sidebar/sidebar_menu.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Services/Targeted%20Expenditure/TE_database.dart';
import 'package:Canny/Shared/input_formatters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
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
                          .map((category) => category.categoryAmount)
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
                            //print(snapshot2.data['amount']);
                            // TODO: decide if TE should be edited this way or the usual way, i anything
                            return Container(
                              child: Column(
                                children: <Widget> [
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              color: Colors.white,
                                              intensity: 5,
                                              depth: -2,
                                              boxShape: NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(10))),
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 70.0, right: 45.0),
                                              child: TextField(
                                                inputFormatters: [
                                                  DecimalTextInputFormatter(
                                                      decimalRange: 2),
                                                  //DecimalPointTextInputFormatter(),
                                                  LengthLimitingTextInputFormatter(6),
                                                ],
                                                textAlign: TextAlign.start,
                                                controller: teController,
                                                decoration: InputDecoration(
                                                  /*
                                                  suffixIcon: IconButton(
                                                      icon: Icon(Icons.check),
                                                      onPressed: () async {
                                                        FocusScope.of(context).requestFocus(FocusNode());
                                                        if (teController.text.isNotEmpty && teController.text != '0') {
                                                          _authTE.updateTE(snapshotData.id, double.parse(teController.text));
                                                        }
                                                        setState(() {
                                                          teAmount = double.parse(teController.text);
                                                          teSet = true;
                                                        });
                                                        teController.clear();
                                                      }),
                                                 */
                                                  border: InputBorder.none,
                                                  labelText: 'Targeted Expenditure: ${snapshotData['amount'] == 0
                                                      ? "Not Set"
                                                      : snapshotData['amount'].toStringAsFixed(2)}',
                                                  labelStyle: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey),
                                                  /*
                                                  hintText: "Enter This Month's Targeted Expenditure",
                                                  hintStyle: TextStyle(
                                                    fontSize: 12, color: Colors.blueGrey),
                                                  hintMaxLines: 2
                                                   */
                                                ),
                                                keyboardType: TextInputType.number,
                                                onSubmitted: (value) {
                                                  FocusScope.of(context).requestFocus(FocusNode());
                                                  if (teController.text.isNotEmpty && teController.text != '0') {
                                                    _authTE.updateTE(double.parse(teController.text));
                                                    teAmount = double.parse(teController.text);
                                                    teSet = true;
                                                  }
                                                  setState(() {});
                                                  teController.clear();
                                                  //print(teSet);
                                                  //print(teAmount);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 350,
                                    child: Card(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget> [
                                          SizedBox(height: 20.0),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget> [
                                              Text('Expenses Breakdown',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "Lato",
                                                    color: kDarkBlue
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 280,
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
                                        ],
                                      ),
                                    ),
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
        .where((category) => category.categoryAmount > 0 && !category.isIncome)
        .toList();
    return List.generate(
      setAmount > 0 && setAmount > sumOfExpensesAmount ? selectedCategories.length + 1 : selectedCategories.length,
          (i) {
        final Category category = i < selectedCategories.length ? selectedCategories[i] : null;
        final bool isTouched = i == donutTouchedIndex;
        //final bool isIncome = i < selectedCategories.length ? category.isIncome : false;
        final double opacity = isTouched ? 1 : 0.6;
        final value = i < selectedCategories.length ? category.categoryAmount : setAmount - sumOfExpensesAmount;
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
}
