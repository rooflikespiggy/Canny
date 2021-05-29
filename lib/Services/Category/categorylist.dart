import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Canny/Models/category';


class CategoryList extends StatefulWidget {
  const CategoryList({Key key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {

    final categories = Provider.of<QuerySnapshot>(context);
    print(categories.docs[0]['Salary']);

    return Container();
  }
}
