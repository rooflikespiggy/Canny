import 'package:cloud_firestore/cloud_firestore.dart';

class TargetedExpenditure {
  double amount;
  DateTime datetime;
  bool set;

  TargetedExpenditure({
    this.amount,
    this.datetime,
    this.set,
  });

  factory TargetedExpenditure.fromMap(DocumentSnapshot doc) {
    Map json = doc.data();

    return TargetedExpenditure(
      amount: json['amount'],
      datetime: json['datetime'],
      set: json['set'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'datetime': DateTime.now(),
      'set': set,
    };
  }
}