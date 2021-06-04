import 'package:Canny/Services/Receipt/receipt_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Services/Receipt/expense_tiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Canny/Database/all_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyExpenses extends StatefulWidget {

  int year;
  String month;

  MonthlyExpenses({
    this.year,
    this.month
  });

  @override
  _MonthlyExpensesState createState() => _MonthlyExpensesState();
}

class _MonthlyExpensesState extends State<MonthlyExpenses> {

  final String uid = FirebaseAuth.instance.currentUser.uid;
  final CollectionReference expensesCollection = Database().expensesDatabase();
  final ReceiptDatabaseService _authReceipt = ReceiptDatabaseService();

  Map<String, int> monthsInYear = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(2),
        child: SingleChildScrollView(
          child: Container(
            child: Card(
              //color: kBackgroundColour,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        widget.month + " " + widget.year.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(
                      height: 20,
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                      color: Colors.blueGrey,
                    ),
                    StreamBuilder(
                        stream: expensesCollection
                            .where('datetime', isGreaterThanOrEqualTo: DateTime(widget.year, monthsInYear[widget.month]))
                            .where('datetime', isLessThan: DateTime(
                            monthsInYear[widget.month] == 12 ? widget.year + 1 : widget.year,
                            monthsInYear[widget.month] == 12 ? 1 : monthsInYear[widget.month] + 1))
                            //.doc("2021-06").collection("2021-06")
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
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(8),
                      children: [
                        ExpenseTile(
                          categoryId: "00",
                          cost: -10,
                          itemName: "pepper lunch",
                          uid: "UID",
                        ),
                        ExpenseTile(
                          categoryId: "01",
                          cost: -1.65,
                          itemName: "",
                          uid: "UID",
                        ),
                        ExpenseTile(
                          categoryId: "02",
                          cost: -19.90,
                          itemName: "UNIQLO t-shirt",
                          uid: "UID",
                        ),
                        ExpenseTile(
                          categoryId: "00",
                          cost: -3.00,
                          itemName: "chicken rice",
                          uid: "UID",
                        ),
                        ExpenseTile(
                          categoryId: "02",
                          cost: -40,
                          itemName: "new wallet",
                          uid: "UID",
                        ),
                      ],
                    ),

                     */

                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}

