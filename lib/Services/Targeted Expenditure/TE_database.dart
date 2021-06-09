import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/targeted_expenditure.dart';
import 'package:Canny/Services/Targeted%20Expenditure/default_TE.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// TODO: figure out how TE will be like
class TEDatabaseService {
  final String uid;

  final CollectionReference teCollection = Database().teDatabase();

  TEDatabaseService({this.uid});

  Future initStartTE() async {
    await addDefaultTE(defaultTE);
    return true;
  }

  Future addDefaultTE(TargetedExpenditure te) async {
    await teCollection
        .add(te.toMap());
    return true;
  }

  Future<List<TargetedExpenditure>> getTE() async {
    List<DocumentSnapshot> snapshots = await teCollection
        .get()
        .then((value) => value.docs);
    return snapshots.map((doc) => TargetedExpenditure.fromMap(doc)).toList();
  }

  Future updateTE(String teId, double newTE) async {
    await teCollection
        .doc(teId)
        .update({
      'amount': newTE,
      'datetime': DateTime.now(),
      'set': true
    });
    return true;
  }

  Future changeTEMonth(String teId) async {
    await teCollection
        .doc(teId)
        .update({
      'amount': 0.0,
      'datetime': DateTime.now(),
      'set': false,
    });
    return true;
  }
}

/*
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
 */