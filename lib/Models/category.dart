import 'package:flutter/material.dart';

class Category {
  String categoryName;
  Color categoryColor;
  Icon categoryIcon;

  Category({
    this.categoryName,
    this.categoryColor,
    this.categoryIcon,
  });

  factory Category.newBlankCategory() {
    return Category(
      categoryName: '',
      categoryIcon: Icon(Icons.check_box_outline_blank_rounded),
      categoryColor: Colors.white,
    );
  }

  Category.fromMap(Map<String, dynamic> json) {
    categoryIcon = json['categoryIconCodePoint'];
    categoryColor = Color(json['categoryColor']);
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'categoryIconCodePoint': categoryIcon.icon.codePoint,
      'categoryColorValue': categoryColor.value,
    };
  }
}