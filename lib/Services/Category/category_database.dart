import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Sidebar/View%20Categories/default_categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class CategoryDatabaseService {

  final String uid;

  // collection reference
  final CollectionReference categoryCollection = Database().categoryDatabase();
  List<Category> categories = defaultCategories;

  CategoryDatabaseService({this.uid});

  Future initStartCategories() async {
    for (int i = 0; i < categories.length; i++) {
      await addDefaultCategory(categories[i]);
    }
    return true;
  }

  Future addDefaultCategory(Category category) async {
    await categoryCollection
        .add(category.toMap());
    return true;
  }

  Future updateCategoryColor(
      String categoryId,
      Color newColor
      ) async {
    await categoryCollection
        .doc(categoryId) //how to get id of each category
        .update({
      "categoryColorValue": newColor.value
    });
    return true;
  }
}
