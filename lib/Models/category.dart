import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category {
  String categoryName;
  Color categoryColor;
  FaIcon categoryIcon;

  Category({
    this.categoryName,
    this.categoryColor,
    this.categoryIcon,
  });

  factory Category.newBlankCategory() {
    return Category(
      categoryName: '',
      categoryIcon: FaIcon(FontAwesomeIcons.question),
      categoryColor: Colors.orange,
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