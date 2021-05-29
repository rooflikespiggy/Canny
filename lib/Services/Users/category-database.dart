import 'package:Canny/Shared/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Canny/Shared/category_tiles.dart';


class CategoryDatabaseService {

  final String uid;
  CategoryDatabaseService({ this.uid });

  //collection reference
  final CollectionReference categoryCollection = FirebaseFirestore.instance.collection('categories');
  Future updateUserData(List<Map<String, String>> defaultCategories) async {
    return await categoryCollection.doc(uid).set({
      'defaultCategories': defaultCategories,
    });
  }

  List<Category> _categoryFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Category(
        defaultCategories: doc['defaultCategories'] ?? {},
      );
    }).toList();
  }


  //get categories stream
  Stream<List<Category>> get categories{
    return categoryCollection.snapshots()
    .map(_categoryFromSnapshot);
  }
}
