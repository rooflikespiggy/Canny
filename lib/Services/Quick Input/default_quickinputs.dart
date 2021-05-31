import 'package:Canny/Models/category.dart';
import 'package:flutter/material.dart';

List<Category> defaultQuickInputs = [
  foodDrinks,
  transportation,
  shopping,
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

Category shopping = Category(
  categoryName: 'Shopping',
  categoryIcon: Icon(Icons.shopping_bag_rounded),
  categoryColor: Colors.pinkAccent,
  categoryId: '02',
);