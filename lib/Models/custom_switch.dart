import 'package:cloud_firestore/cloud_firestore.dart';

class CustomSwitch {
  bool balance;
  bool expenseBreakdown;
  bool expenseSummary;
  bool expenseReceipts;
  bool incomeReceipts;

  CustomSwitch({
    this.balance = true,
    this.expenseBreakdown = true,
    this.expenseSummary = true,
    this.expenseReceipts = true,
    this.incomeReceipts = true,
  });

  factory CustomSwitch.fromMap(DocumentSnapshot doc) {
    Map json = doc.data();

    return CustomSwitch(
      balance: json['balance'],
      expenseBreakdown: json['expenseBreakdown'],
      expenseSummary: json['expenseSummary'],
      expenseReceipts: json['expenseReceipts'],
      incomeReceipts: json['incomeReceipts'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
      'expenseBreakdown': expenseBreakdown,
      'expenseSummary': expenseSummary,
      'expenseReceipts': expenseReceipts,
      'incomeReceipts': incomeReceipts,
    };
  }
}