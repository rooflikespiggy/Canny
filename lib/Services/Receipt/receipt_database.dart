import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptDatabaseService {

  final CollectionReference expensesCollection = Database().expensesDatabase();

  Future addExpense(Expense expense) async {
    await expensesCollection.add(expense.toMap());
    return true;
  }

}