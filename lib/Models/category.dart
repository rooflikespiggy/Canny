import 'package:flutter/material.dart';

class Category {
  String categoryName;
  Color categoryColor;
  Icon categoryIcon;
  String categoryId;

  Category({
    this.categoryName,
    this.categoryColor,
    this.categoryIcon,
    this.categoryId
  });

  factory Category.newBlankCategory() {
    return Category(
      categoryName: '',
      categoryIcon: Icon(Icons.check_box_outline_blank_rounded),
      categoryColor: Colors.white,
      categoryId: ''
    );
  }

  Category.fromMap(Map<String, dynamic> json) {
    categoryIcon = json['categoryIconCodePoint'];
    categoryColor = Color(json['categoryColorValue']);
    categoryName = json['categoryName'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'categoryIconCodePoint': categoryIcon.icon.codePoint,
      'categoryColorValue': categoryColor.value,
      'categoryId': categoryId,
    };
  }
}