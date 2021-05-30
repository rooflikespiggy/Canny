import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Sidebar/View%20Categories/default_categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class CategoryDatabaseService {

  final String uid;

  // collection reference
  final CollectionReference categoryCollection = FirebaseFirestore.instance
      .collection('Users');
  List<Category> categories = defaultCategories;

  CategoryDatabaseService({this.uid});

  Future initStartCategories() async {
    for (int i = 0; i < categories.length; i++) {
      await categoryCollection
          .doc(uid)
          .collection("Categories")
          .add(categories[i].toMap());
    }
    return true;
  }

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
    });
    return true;
  }
}

