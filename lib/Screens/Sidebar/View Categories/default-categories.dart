import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DefaultCategories {

  List<Map<String, String>> createList() {
    return [
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
