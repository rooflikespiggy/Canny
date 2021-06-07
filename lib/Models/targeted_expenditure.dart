import 'package:cloud_firestore/cloud_firestore.dart';

class TargetedExpenditure {
  double amount;

  TargetedExpenditure({
    this.amount,
  });

  factory TargetedExpenditure.fromMap(DocumentSnapshot doc) {
    Map json = doc.data();

    return TargetedExpenditure(
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
    };
  }
}