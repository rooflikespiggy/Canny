import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Services/Quick Input/default_quickinputs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuickInputDatabaseService {
  final String uid;

  // collection reference
  final CollectionReference quickInputCollection = Database().quickInputDatabase();
  final String userId = FirebaseAuth.instance.currentUser.uid;
  List<Category> _quickInputs;
  var quickInputs = {FirebaseAuth.instance.currentUser.uid: defaultQuickInputs};

  QuickInputDatabaseService({this.uid});

  Future initStartQuickInputs() async {
    await addDefaultQuickInput(defaultQuickInputs[0], 0);
    await addDefaultQuickInput(defaultQuickInputs[1], 1);
    await addDefaultQuickInput(defaultQuickInputs[2], 2);
    return true;
  }

  Future addDefaultQuickInput(Category category, int categoryId) async {
    await quickInputCollection
        .doc(categoryId.toString())
        .set(category.toMap());
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

  Future updateQuickInput(Category category, String categoryId, int categoryNo) async {
    /*
    String previousCategoryId = int.parse(quickInputs[userId][categoryNo].categoryId).toString();
    await quickInputCollection
        .doc(previousCategoryId)
        .delete();
     */
    await quickInputCollection
        .get()
        .then((snapshot) =>
        snapshot.docs.forEach((element) =>
            element.reference.delete()));
    await quickInputCollection
        .doc(int.parse(categoryId).toString())
        .set(category.toMap());
    quickInputs[userId][categoryNo] = category;
    return true;
  }

  Category getQuickInput(int categoryNo) {
    return quickInputs[userId][categoryNo];
  }

}