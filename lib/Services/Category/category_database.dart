import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Sidebar/View%20Categories/default_categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class CategoryDatabaseService {

  final String uid;

  // collection reference
<<<<<<< HEAD
  final CollectionReference categoryCollection = Database().categoryDatabase();
=======
  final CollectionReference categoryCollection = FirebaseFirestore.instance
      .collection('Users');
>>>>>>> 93795b980f1bd123495f0e5a47338e93f254dfcb
  List<Category> categories = defaultCategories;

  CategoryDatabaseService({this.uid});

  Future initStartCategories() async {
    for (int i = 0; i < categories.length; i++) {
      await addDefaultCategory(categories[i]);
    }
    return true;
  }

<<<<<<< HEAD
  Future addDefaultCategory(Category category) async {
    await categoryCollection
        .add(category.toMap());
    return true;
  }

  /*
  Future updateUserData(List<Map<String, String>> defaultCategories) async {
    return await categoryCollection.doc(uid).set({
      'Food and Drink': defaultCategories[0],
      'Transportation': defaultCategories[1],
      'Shopping': defaultCategories[2],
      'Entertainment': defaultCategories[3],
      'Bills and Fees': defaultCategories[4],
      'Education': defaultCategories[5],
      'Gift': defaultCategories[6],
      'Household': defaultCategories[7],
      'Allowance': defaultCategories[8],
      'Salary': defaultCategories[9],
      'Loan': defaultCategories[10],
      'Other': defaultCategories[11],
=======
  Future updateCategoryColor(
      String catName,
      Color newColor
      ) async {
    await categoryCollection
        .doc(uid)
        .collection("Categories")
        .doc(catName) //how to get id of each category
        .update({
      "categoryColorValue": newColor.value
>>>>>>> 93795b980f1bd123495f0e5a47338e93f254dfcb
    });
    return true;
  }
}

