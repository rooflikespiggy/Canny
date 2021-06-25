import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Services/Quick Input/default_quickinputs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuickInputDatabaseService {
  final String uid;

  // collection reference
  final CollectionReference quickInputCollection = Database().quickInputDatabase();
  List<Category> _quickInputs;

  QuickInputDatabaseService({this.uid});

  Future initStartQuickInputs() async {
    await addDefaultQuickInput(defaultQuickInputs[0]);
    await addDefaultQuickInput(defaultQuickInputs[1]);
    await addDefaultQuickInput(defaultQuickInputs[2]);
    return true;
  }

  Future addDefaultQuickInput(Category category) async {
    await quickInputCollection
        .add(category.toMap());
    return true;
  }

  Future<List<Category>> getQuickInputs() async {
    List<DocumentSnapshot> snapshots = await quickInputCollection
        .get()
        .then((value) => value.docs);
    return snapshots.map((doc) => Category.fromMap(doc)).toList();
  }

  Future initNewQuickInputs() async {
    _quickInputs = await getQuickInputs();
  }

  List<Category> get allQuickInputs {
    return _quickInputs;
  }

  Future updateQuickInput(Category category, String quickInputId) async {
    await quickInputCollection
        .doc(quickInputId)
        .update(category.toMap());
    return true;
  }

  Future updateFirstQuickInput(Category category) async {
    await quickInputCollection
        .doc('0')
        .update(category.toMap());
    return true;
  }

  Future updateSecondQuickInput(Category category) async {
    await quickInputCollection
        .doc('1')
        .update(category.toMap());
    return true;
  }

  Future updateThirdQuickInput(Category category) async {
    await quickInputCollection
        .doc('2')
        .update(category.toMap());
    return true;
  }

  Future changeQuickInputToOthers(Category category, String quickInputId) async {
    await quickInputCollection
        .doc(quickInputId)
        .update(category.toMap());
    return true;
  }
}