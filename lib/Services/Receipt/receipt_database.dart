import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

class ReceiptDatabaseService {

  final CollectionReference expensesCollection = Database().expensesDatabase();
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final String monthYear = DateFormat('MMM y').format(DateTime.now());

  Future addReceipt(Expense expense) async {
    await expensesCollection.add(expense.toMap());
    await categoryCollection
        .doc(int.parse(expense.categoryId).toString())
        .update({
      "categoryAmount.$monthYear": FieldValue.increment(expense.cost.abs())
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
      Timestamp date,
      double cost) async {
    String formattedDate = DateFormat('MMM y')
        .format(DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000));
    await expensesCollection
        .doc(receiptId)
        .delete();
    await categoryCollection
        .doc(int.parse(categoryId).toString())
        .update({
      "categoryAmount.$formattedDate": FieldValue.increment(-(cost.abs()))
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
      Timestamp date,
      double oldCost,
      double newCost) async {
    String formattedDate = DateFormat('MMM y')
        .format(DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000));
    await expensesCollection
        .doc(receiptId)
        .update({
      'cost': newCost,
    });
    await categoryCollection
        .doc(int.parse(categoryId).toString())
        .update({
      "categoryAmount.$formattedDate": FieldValue.increment(newCost.abs() - oldCost.abs())
    });
    return true;
  }

  Future updateCostAndCategory(String receiptId,
      String oldCategoryId,
      String newCategoryId,
      Timestamp date,
      double oldCost,
      double newCost) async {
    String formattedDate = DateFormat('MMM y')
        .format(DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000));
    await expensesCollection
        .doc(receiptId)
        .update({
      'cost': newCost,
      'categoryId': newCategoryId,
    });
    await categoryCollection
        .doc(int.parse(newCategoryId).toString())
        .update({
      "categoryAmount.$formattedDate": FieldValue.increment(newCost.abs())
    });
    await categoryCollection
        .doc(int.parse(oldCategoryId).toString())
        .update({
      "categoryAmount.$formattedDate": FieldValue.increment(-(oldCost.abs()))
    });
    return true;
  }

  Future updateDate(String receiptId,
      Timestamp oldDate,
      DateTime newDate,
      String categoryId,
      double cost) async {
    String formattedOldDate = DateFormat('MMM y')
        .format(DateTime.fromMillisecondsSinceEpoch(oldDate.seconds * 1000));
    String formattedNewDate = DateFormat('MMM y').format(newDate);
    await expensesCollection
        .doc(receiptId)
        .update({
      'datetime': newDate,
    });
    await categoryCollection
        .doc(int.parse(categoryId).toString())
        .update({
      "categoryAmount.$formattedOldDate": FieldValue.increment(-(cost.abs()))
    });
    await categoryCollection
        .doc(int.parse(categoryId).toString())
        .update({
      "categoryAmount.$formattedNewDate": FieldValue.increment(cost.abs())
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