import 'package:flutter/material.dart';
import 'package:Canny/Services/Receipt/expense_tiles.dart';

class monthlyExpenses extends StatefulWidget {

  String month;

  monthlyExpenses({ this.month });

  @override
  _monthlyExpensesState createState() => _monthlyExpensesState();
}

class _monthlyExpensesState extends State<monthlyExpenses> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(2),
        child: SingleChildScrollView(
          child: Container(
            child: Card(
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
                        widget.month,
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

                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}

