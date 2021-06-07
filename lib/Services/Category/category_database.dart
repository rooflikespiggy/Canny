import 'dart:async';
import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Services/Category/default_categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CategoryDatabaseService {
  final String uid;

  // collection reference
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final String userId = FirebaseAuth.instance.currentUser.uid;
  List<Category> _categories;
  //var categories = {FirebaseAuth.instance.currentUser.uid: defaultCategories};
  final CollectionReference receiptCollection = Database().expensesDatabase();

  CategoryDatabaseService({this.uid});


  Future<List<Category>> getCategories() async {
    List<DocumentSnapshot> snapshots = await categoryCollection
        .get()
        .then((value) => value.docs);
    return snapshots.map((doc) => Category.fromMap(doc)).toList();
  }

  Future initNewCategories() async {
    _categories = await getCategories();
  }

  List<Category> get allCategories {
    initNewCategories();
    return _categories;
  }

  Future initStartCategories() async {
    for (int i = 0; i < defaultCategories.length; i++) {
      await addDefaultCategory(defaultCategories[i], i.toString());
    }
    return true;
  }

  Future addDefaultCategory(Category category, String categoryId) async {
    await categoryCollection
        .doc(categoryId)
        .set(category.toMap());
    return true;
  }

  Future addNewCategory(Category category, String categoryId) async {
    // categories[userId].add(category);
    await categoryCollection
        .doc(categoryId)
        .set(category.toMap());
    return true;
  }

  Future removeCategory(String categoryId, double categoryAmount) async {
    // if removeCategory all the expenses should go to Others category
    /*
    for (Category category in categories[userId]) {
      if (category.categoryId == categoryId) {
        categories[userId].remove(category);
      }
    }
    await receiptCollection
        .where('categoryId', isEqualTo: categoryId)
        .get()
        .then((value) => null);
    //how to update the categoryid value to 11 for each expense
     */
    await categoryCollection
        .doc(categoryId)
        .delete();
    await categoryCollection
        .doc('11')
        .update({
      'categoryAmount': FieldValue.increment(categoryAmount)
    });
    return true;
  }

  Future updateCategoryColor(String categoryId, Color newColor) async {
    await categoryCollection
        .doc(int.parse(categoryId).toString()) //how to get id of each category
        .update({
      "categoryColorValue": newColor.value
        });
    return true;
  }

  /*
  Category getCategory(String categoryId) {
    for (Category category in categories[userId]) {
      if (category.categoryId == categoryId) {
        return category;
      }
    }
    return categories[userId].first;
  }

  List<Category> getAllCategories() {
    return categories[userId];
  }
   */
}
