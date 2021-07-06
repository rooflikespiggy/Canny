import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/custom_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'default_dashboard.dart';

class DashboardDatabaseService {
  final String uid;
  final CollectionReference dashboardCollection = Database().dashboardDatabase();

  DashboardDatabaseService({this.uid});

  Future initStartSwitch() async {
    await addSwitch(defaultSwitch);
    return true;
  }

  Future addSwitch(CustomSwitch switches) async {
    await dashboardCollection
        .doc('Switch')
        .set(switches.toMap());
    return true;
  }

  Future<CustomSwitch> getSwitch() async {
    List<DocumentSnapshot> snapshots = await dashboardCollection
        .get()
        .then((value) => value.docs);
    return snapshots.map((doc) => CustomSwitch.fromMap(doc)).first;
  }

  Future updateBudget(bool budgetCustom) async {
    await dashboardCollection
        .doc('Switch')
        .update({
      'balance': budgetCustom,
    });
    return true;
  }

  Future updateExpenseBreakdown(bool breakdownCustom) async {
    await dashboardCollection
        .doc('Switch')
        .update({
      'expenseBreakdown': breakdownCustom,
    });
    return true;
  }

  Future updateExpenseSummary(bool summaryCustom) async {
    await dashboardCollection
        .doc('Switch')
        .update({
      'expenseSummary': summaryCustom,
    });
    return true;
  }

  Future updateExpenseReceipts(bool expenseReceiptCustom) async {
    await dashboardCollection
        .doc('Switch')
        .update({
      'expenseReceipts': expenseReceiptCustom,
    });
    return true;
  }

  Future updateIncomeReceipts(bool incomeReceiptCustom) async {
    await dashboardCollection
        .doc('Switch')
        .update({
      'incomeReceipts': incomeReceiptCustom,
    });
    return true;
  }

  /*
  Future updateRecentReceipts(bool receiptCustom) async {
    await dashboardCollection
        .doc('Switch')
        .update({
      'recentReceipts': receiptCustom,
    });
    return true;
  }
   */

}