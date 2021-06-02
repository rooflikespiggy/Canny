import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String categoryId;
  double cost;
  DateTime datetime = DateTime.now();
  String itemName;
  String uid;

  Expense({
    this.categoryId,
    this.cost,
    this.datetime,
    this.itemName,
    this.uid,
  });

  factory Expense.fromMap(DocumentSnapshot doc) {
    Map json = doc.data();

    return Expense(
      categoryId: json['categoryId'],
      cost: json['cost'],
      datetime: json['datetime'],
      itemName: json['itemName'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'cost': cost,
      'datetime': datetime,
      'itemName': itemName,
      'uid': uid,
    };
  }
}