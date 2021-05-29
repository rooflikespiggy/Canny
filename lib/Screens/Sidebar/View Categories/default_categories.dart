import 'package:Canny/Models/category.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


List<Category> defaultCategories = [
  foodDrinks,
  transportation,
  shopping,
  entertainment,
  billAndFees,
  education,
  gift,
  household,
  allowance,
  salary,
  loan,
  others,
];

Category foodDrinks = Category(
  categoryName: 'Food & Drinks',
  categoryIcon: FaIcon(FontAwesomeIcons.hamburger),
  categoryColor: Colors.green[800],
);

Category transportation = Category(
  categoryName: 'Transportation',
  categoryIcon: FaIcon(FontAwesomeIcons.car),
  categoryColor: Colors.red[800],
);

Category shopping = Category(
  categoryName: 'Shopping',
  categoryIcon: FaIcon(FontAwesomeIcons.shoppingBag),
  categoryColor: Colors.pinkAccent,
);

Category entertainment = Category(
  categoryName: 'Entertainment',
  categoryIcon: FaIcon(FontAwesomeIcons.film),
  categoryColor: Colors.deepOrange,
);

Category billAndFees = Category(
  categoryName: 'Bills and Fees',
  categoryIcon: FaIcon(FontAwesomeIcons.fileInvoiceDollar),
  categoryColor: Colors.purple[800],
);

Category education = Category(
  categoryName: 'Education',
  categoryIcon: FaIcon(FontAwesomeIcons.graduationCap),
  categoryColor: Colors.blue,
);

Category gift = Category(
  categoryName: 'Gift',
  categoryIcon: FaIcon(FontAwesomeIcons.gift),
  categoryColor: Colors.amber[700],
);

Category household = Category(
  categoryName: 'Household',
  categoryIcon: FaIcon(FontAwesomeIcons.couch),
  categoryColor: Colors.teal,
);

Category allowance = Category(
  categoryName: 'Allowance',
  categoryIcon: FaIcon(FontAwesomeIcons.handHoldingUsd),
  categoryColor: Colors.indigo[600],
);

Category salary = Category(
  categoryName: 'Salary',
  categoryIcon: FaIcon(FontAwesomeIcons.moneyBillWave),
  categoryColor: Colors.pink[900],
);

Category loan = Category(
  categoryName: 'Loan',
  categoryIcon: FaIcon(FontAwesomeIcons.landmark),
  categoryColor: Colors.orange,
);

Category others = Category(
  categoryName: 'Others',
  categoryIcon: FaIcon(FontAwesomeIcons.archive),
  categoryColor: Colors.grey,
);

/*
class DefaultCategories {

  List<Map<String, String>> createList() {
    return [
      {Category()}
      {'categoryName': "Food and Drinks", 'categoryColor':Colors.green[800].value.toString(), 'categoryIcon': FaIcon(FontAwesomeIcons.hamburger).toString()},
      {'categoryName': "Transportation", 'categoryColor':Colors.red[800].value.toString(), 'categoryIcon': FaIcon(FontAwesomeIcons.car).toString()},
      {'categoryName': "Shopping", 'categoryColor':Colors.pinkAccent.value.toString(), 'categoryIcon': FaIcon(FontAwesomeIcons.shoppingBag).toString()},
      {'categoryName': "Entertainment", 'categoryColor':Colors.deepOrange.value.toString(), 'categoryIcon': FaIcon(FontAwesomeIcons.film).toString()},
      {'categoryName': "Bills and Fees", 'categoryColor':Colors.purple[800].value.toString(), 'categoryIcon': FaIcon(FontAwesomeIcons.fileInvoiceDollar).toString()},
      {'categoryName': "Education", 'categoryColor':Colors.blue.value.toString(), 'categoryIcon': FaIcon(FontAwesomeIcons.graduationCap).toString()},
      {'categoryName': "Gift", 'categoryColor':Colors.amber[700].value.toString(), 'categoryIcon': FaIcon(FontAwesomeIcons.gift).toString()},
      {'categoryName': "Household", 'categoryColor':Colors.teal.value.toString(), 'categoryIcon': FaIcon(FontAwesomeIcons.couch).toString()},
      {'categoryName': "Allowance", 'categoryColor':Colors.indigo[600].value.toString(), 'categoryIcon': FaIcon(FontAwesomeIcons.handHoldingUsd).toString()},
      {'categoryName': "Salary", 'categoryColor':Colors.pink[900].value.toString(), 'categoryIcon': FaIcon(FontAwesomeIcons.moneyBillWave).toString()},
      {'categoryName': "Loan", 'categoryColor':Colors.orange.value.toString(), 'categoryIcon': FaIcon(FontAwesomeIcons.landmark).toString()},
      {'categoryName': "Other", 'categoryColor':Colors.grey[800].value.toString(), 'categoryIcon': FaIcon(FontAwesomeIcons.archive).toString()},
    ];
  }
}
 */
