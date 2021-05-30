import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Services/Category/default_categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryDatabaseService {
  final String uid;

  // collection reference
  final CollectionReference categoryCollection = Database().categoryDatabase();
  List<Category> categories = defaultCategories;

  CategoryDatabaseService({this.uid});

  Category getCategories(String categoryId) {
    return categories[int.parse(categoryId)];
  }

  Future initStartCategories() async {
    for (int i = 0; i < categories.length; i++) {
      await addDefaultCategory(categories[i], i);
    }
    return true;
  }

  Future addDefaultCategory(Category category, int categoryId) async {
    await categoryCollection
        .doc(categoryId.toString())
        .set(category.toMap());
    return true;
  }

  Future addNewCategory(Category category) async {
    categories.add(category);
    await categoryCollection
        .doc((categories.length - 1).toString())
        .set(category.toMap());
    return true;
  }

  Future removeCategory(String id) async {
    // if removeCategory all the expenses should go to Others category
    categories.remove(id);
    await categoryCollection
        .doc(id)
        .delete();
    return true;
  }

  Future updateCategoryColor(String categoryId, Color newColor) async {
    await categoryCollection.doc(categoryId) //how to get id of each category
        .update({"categoryColorValue": newColor.value});
    return true;
  }
}
