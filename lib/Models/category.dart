import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Category {
  // should add isIncome and categoryAmount
  String categoryName;
  Color categoryColor;
  Icon categoryIcon;
  String categoryId;
  double categoryAmount;
  bool isIncome;

  Category({
    this.categoryName,
    this.categoryColor,
    this.categoryIcon,
    this.categoryId,
    this.categoryAmount,
    this.isIncome
  });

  factory Category.newBlankCategory() {
    return Category(
      categoryName: '',
      categoryIcon: Icon(Icons.check_box_outline_blank_rounded),
      categoryColor: Colors.white,
      categoryId: ''
    );
  }

  /*
  Category.fromMap(Map<String, dynamic> json) {
    categoryIcon = json['categoryIconCodePoint'];
    categoryColor = Color(json['categoryColorValue']);
    categoryName = json['categoryName'];
    categoryId = json['categoryId'];
  }
   */

  factory Category.fromMap(DocumentSnapshot doc) {
    Map json = doc.data();

    return Category(
      categoryIcon: Icon(IconData(
          json['categoryIconCodePoint'],
          fontFamily: json['categoryFontFamily'],
          fontPackage: json['categoryFontPackage'])
      ),
      categoryColor: Color(json['categoryColorValue']),
      categoryName: json['categoryName'],
      categoryId: json['categoryId'],
      categoryAmount: json['categoryAmount'],
      isIncome: json['isIncome']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'categoryIconCodePoint': categoryIcon.icon.codePoint,
      'categoryFontFamily': categoryIcon.icon.fontFamily,
      'categoryFontPackage': categoryIcon.icon.fontPackage,
      'categoryColorValue': categoryColor.value,
      'categoryId': categoryId,
      'categoryAmount': categoryAmount,
      'isIncome': isIncome,
    };
  }
}