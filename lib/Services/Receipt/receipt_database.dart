import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReceiptDatabaseService {

  final CollectionReference expensesCollection = Database().expensesDatabase();
  final CollectionReference categoryCollection = Database().categoryDatabase();

  Future addExpense(Expense expense) async {
    await expensesCollection
        //.doc(DateFormat('yyyy-MM').format(expense.datetime))
        //.collection(DateFormat('yyyy-MM').format(expense.datetime))
        .add(expense.toMap());
    await categoryCollection
        .doc(int.parse(expense.categoryId).toString())
        .update({
      "categoryAmount": FieldValue.increment(expense.cost)
    });
    return true;
  }

}