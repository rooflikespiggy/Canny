import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:Canny/Shared/category.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {

    final categories = Provider.of<List<Category>>(context);
    categories.forEach((cat) {
      print(cat.defaultCategories);
    });

    return Container();
  }
}
