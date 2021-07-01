import 'package:cloud_firestore/cloud_firestore.dart';

class CustomSwitch {
  bool balance;
  bool expenseBreakdown;
  bool expenseSummary;
  bool recentReceipts;
  // bool expenseAverage;

  CustomSwitch({
    this.balance = true,
    this.expenseBreakdown = true,
    this.expenseSummary = true,
    this.recentReceipts = true,
    // this.expenseAverage = true,
  });

  factory CustomSwitch.fromMap(DocumentSnapshot doc) {
    Map json = doc.data();

    return CustomSwitch(
      balance: json['balance'],
      expenseBreakdown: json['expenseBreakdown'],
      expenseSummary: json['expenseSummary'],
      recentReceipts: json['recentReceipts'],
      // expenseAverage: json['expenseAverage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
      'expenseBreakdown': expenseBreakdown,
      'expenseSummary': expenseSummary,
      'recentReceipts': recentReceipts,
      // 'expenseAverage': expenseAverage,
    };
  }
}