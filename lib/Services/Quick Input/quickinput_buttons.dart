import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Services/Quick%20Input/quickinput_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'calculator_icon_buttons.dart';

class QuickInputButton extends StatefulWidget {
  QueryDocumentSnapshot<Object> chosenCategory = null;

  @override
  _QuickInputButtonState createState() => _QuickInputButtonState();
}

class _QuickInputButtonState extends State<QuickInputButton> {
  final QuickInputDatabaseService _authQuickInput = QuickInputDatabaseService();
  final CollectionReference quickInputCollection = Database().categoryDatabase();

  void catClick(QueryDocumentSnapshot<Object> category) {
    setState(() {widget.chosenCategory = category;});
  }

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
                children: <Widget>[
                  CalcIconButton(
                    category: snapshot.data.docs[0],
                    icon: Icon(
                        IconData(snapshot.data.docs[0]['categoryIconCodePoint'],
                            fontFamily: snapshot.data
                                .docs[0]['categoryFontFamily'],
                            fontPackage: snapshot.data
                                .docs[0]['categoryFontPackage'])),
                    categoryColor: Color(
                        snapshot.data.docs[0]['categoryColorValue']),
                    fillColor: Colors.deepOrange[100],
                    callback: catClick,
                  ),
                  SizedBox(width: 6.5),
                  CalcIconButton(
                    category: snapshot.data.docs[1],
                    icon: Icon(
                        IconData(snapshot.data.docs[1]['categoryIconCodePoint'],
                            fontFamily: snapshot.data
                                .docs[1]['categoryFontFamily'],
                            fontPackage: snapshot.data
                                .docs[1]['categoryFontPackage'])),
                    categoryColor: Color(
                        snapshot.data.docs[1]['categoryColorValue']),
                    fillColor: Colors.deepOrange[100],
                    callback: catClick,
                  ),
                  SizedBox(width: 6.5),
                  CalcIconButton(
                    category: snapshot.data.docs[2],
                    icon: Icon(
                        IconData(snapshot.data.docs[2]['categoryIconCodePoint'],
                            fontFamily: snapshot.data
                                .docs[2]['categoryFontFamily'],
                            fontPackage: snapshot.data
                                .docs[2]['categoryFontPackage'])),
                    categoryColor: Color(
                        snapshot.data.docs[2]['categoryColorValue']),
                    fillColor: Colors.deepOrange[100],
                    callback: catClick,
                  ),
                ],
              ),
            );
          }
        }
      ),
    );
  }
}


  