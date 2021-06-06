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

  Future<List<Expense>> getReceipt() async {
    List<DocumentSnapshot> snapshots = await expensesCollection
        .get()
        .then((value) => value.docs);
    return snapshots.map((doc) => Expense.fromMap(doc)).toList();
  }

  Future removeExpenses(String receiptId,
      String categoryId,
      int cost) async {
    await expensesCollection
        .doc(receiptId)
        .delete();
    await categoryCollection
        .doc(int.parse(categoryId).toString())
        .update({
      "categoryAmount": FieldValue.increment(-cost)
    });
    return true;
  }

  Future updateExpenses(String receiptId,
      String newCategoryId,
      String newItemName,
      int newCost) async {
    await expensesCollection
        .doc(receiptId)
        .update({
      'categoryId': newCategoryId,
      'itemName': newItemName,
      'cost': newCost,
    });
    await categoryCollection
        .doc(int.parse(newCategoryId).toString())
        .update({
      "categoryAmount": FieldValue.increment(newCost)
    });
    return true;
  }

}