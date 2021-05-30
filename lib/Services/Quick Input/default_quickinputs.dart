import 'package:Canny/Models/category.dart';
import 'package:flutter/material.dart';

List<Category> defaultQuickInputs = [
  foodDrinks,
  transportation,
  others,
];

Category foodDrinks = Category(
  categoryName: 'Food & Drinks',
  categoryIcon: Icon(Icons.fastfood_rounded),
  categoryColor: Colors.green[800],
  categoryId: '00',
);

Category transportation = Category(
  categoryName: 'Transportation',
  categoryIcon: Icon(Icons.directions_bus),
  categoryColor: Colors.red[800],
  categoryId: '01',
);

Category others = Category(
  categoryName: 'Others',
  categoryIcon: Icon(Icons.scatter_plot),
  categoryColor: Colors.grey[700],
  categoryId: '11',
);