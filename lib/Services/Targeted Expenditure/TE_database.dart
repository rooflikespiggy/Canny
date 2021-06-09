import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/targeted_expenditure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TEDatabaseService {
  final String uid;

  TEDatabaseService({this.uid});

  final CollectionReference TECollection = Database().targetedExpenditureDatabase();
  final String userId = FirebaseAuth.instance.currentUser.uid;

  Future addTargetedExpenditure() async {
    TargetedExpenditure targetedExpenditure = new TargetedExpenditure(amount: 1000);
    await TECollection
        .doc('Targeted Expenditure')
        .set(targetedExpenditure.toMap());
    return true;
  }

  Future updateTargetedExpenditure(TargetedExpenditure targetedExpenditure) async {
    await TECollection
        .doc('Targeted Expenditure')
        .update(targetedExpenditure.toMap());
    return true;
  }

}