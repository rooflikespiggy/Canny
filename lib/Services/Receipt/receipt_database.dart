import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReceiptDatabaseService {

  final CollectionReference expensesCollection = Database().expensesDatabase();
  final CollectionReference categoryCollection = Database().categoryDatabase();

  Future addReceipt(Expense expense) async {
    await expensesCollection
        //.doc(DateFormat('yyyy-MM').format(expense.datetime))
        //.collection(DateFormat('yyyy-MM').format(expense.datetime))
        .add(expense.toMap());
    await categoryCollection
        .doc(int.parse(expense.categoryId).toString())
        .update({
      "categoryAmount": FieldValue.increment(expense.cost.abs())
    });
    return true;
  }

  Future<List<Expense>> getReceipt() async {
    List<DocumentSnapshot> snapshots = await expensesCollection
        .get()
        .then((value) => value.docs);
    return snapshots.map((doc) => Expense.fromMap(doc)).toList();
  }

  Future removeReceipt(String receiptId,
      String categoryId,
      double cost) async {
    await expensesCollection
        .doc(receiptId)
        .delete();
    await categoryCollection
        .doc(int.parse(categoryId).toString())
        .update({
      "categoryAmount": FieldValue.increment(-(cost.abs()))
    });
    return true;
  }

  Future updateItemName(String receiptId, String newItemName) async {
    await expensesCollection
        .doc(receiptId)
        .update({
      'itemName': newItemName,
    });
    return true;
  }

  Future updateCost(String receiptId,
      String categoryId,
      double oldCost,
      double newCost) async {
    await expensesCollection
        .doc(receiptId)
        .update({
      'cost': newCost,
    });
    await categoryCollection
        .doc(int.parse(categoryId).toString())
        .update({
      "categoryAmount": FieldValue.increment(newCost.abs() - oldCost.abs())
    });
    return true;
  }

  Future updateCostAndCategory(String receiptId,
      String oldCategoryId,
      String newCategoryId,
      double oldCost,
      double newCost) async {
    await expensesCollection
        .doc(receiptId)
        .update({
      'cost': newCost,
      'categoryId': newCategoryId,
    });
    await categoryCollection
        .doc(int.parse(newCategoryId).toString())
        .update({
      "categoryAmount": FieldValue.increment(newCost.abs())
    });
    await categoryCollection
        .doc(int.parse(oldCategoryId).toString())
        .update({
      "categoryAmount": FieldValue.increment(-(oldCost.abs()))
    });
    return true;
  }

  Future updateDate(String receiptId, DateTime newDate) async {
    await expensesCollection
        .doc(receiptId)
        .update({
      'datetime': newDate,
    });
    return true;
  }

  Future changeCategoryToOthers(String receiptId) async {
    await expensesCollection
        .doc(receiptId)
        .update({
      'categoryId': '11',
    });
    return true;
  }

  /*
  Future updateCategory(String receiptId,
      String oldCategoryId,
      String newCategoryId,
      double cost) async {
    await expensesCollection
        .doc(receiptId)
        .update({
      'categoryId': newCategoryId,
    });
    await categoryCollection
        .doc(int.parse(newCategoryId).toString())
        .update({
      "categoryAmount": FieldValue.increment(cost)
    });
    await categoryCollection
        .doc(int.parse(oldCategoryId).toString())
        .update({
      "categoryAmount": FieldValue.increment(-cost)
    });
    return true;
  }

  Future updateReceipt(String receiptId,
      String oldCategoryId,
      String newCategoryId,
      String newItemName,
      DateTime newDate,
      double newCost) async {
    await expensesCollection
        .doc(receiptId)
        .update({
      'categoryId': newCategoryId,
      'itemName': newItemName,
      'datetime': newDate,
      'cost': newCost,
    });
    await categoryCollection
        .doc(int.parse(newCategoryId).toString())
        .update({
      "categoryAmount": FieldValue.increment(newCost)
    });
    await categoryCollection
        .doc(int.parse(oldCategoryId).toString())
        .update({
      "categoryAmount": FieldValue.increment(-newCost)
    });
    return true;
  }
   */
}