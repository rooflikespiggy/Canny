import 'package:Canny/Models/targeted_expenditure.dart';

TargetedExpenditure defaultTE = unsetTE;

TargetedExpenditure unsetTE = TargetedExpenditure(
  amount: 500.0,
  datetime: DateTime.now(),
  set: false,
);