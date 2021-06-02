import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Services/Quick%20Input/quickinput_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'calculator_icon_buttons.dart';

class QuickInputButton extends StatelessWidget {
  final QuickInputDatabaseService _authQuickInput = QuickInputDatabaseService();
  final CollectionReference quickInputCollection = Database().categoryDatabase();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: quickInputCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget> [
                  CalcIconButton(
                    icon: Icon(IconData(snapshot.data.docs[0]['categoryIconCodePoint'],
                        fontFamily: snapshot.data.docs[0]['categoryFontFamily'],
                        fontPackage: snapshot.data.docs[0]['categoryFontPackage'])),
                    categoryColor: Color(snapshot.data.docs[0]['categoryColorValue']),
                    fillColor: Colors.orange[200],
                  ),
                  SizedBox(width: 6.5),
                  CalcIconButton(
                    icon: Icon(IconData(snapshot.data.docs[1]['categoryIconCodePoint'],
                        fontFamily: snapshot.data.docs[1]['categoryFontFamily'],
                        fontPackage: snapshot.data.docs[1]['categoryFontPackage'])),
                    categoryColor: Color(snapshot.data.docs[1]['categoryColorValue']),
                    fillColor: Colors.orange[200],
                  ),
                  SizedBox(width: 6.5),
                  CalcIconButton(
                    icon: Icon(IconData(snapshot.data.docs[2]['categoryIconCodePoint'],
                        fontFamily: snapshot.data.docs[2]['categoryFontFamily'],
                        fontPackage: snapshot.data.docs[2]['categoryFontPackage'])),
                    categoryColor: Color(snapshot.data.docs[2]['categoryColorValue']),
                    fillColor: Colors.orange[200],
                  ),
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        }
      ),
    );
  }
}