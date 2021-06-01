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
  var quickInputs = {FirebaseAuth.instance.currentUser.uid: defaultQuickInputs};

  QuickInputDatabaseService({this.uid});


  Category getQuickInput(String categoryId) {
    for (Category category in quickInputs[userId]) {
      if (category.categoryId == categoryId) {
        return category;
      }
    }
    return quickInputs[userId].first;
  }

  Category getSpecificQuickInput(int categoryNo) {
    return quickInputs[userId][categoryNo];
  }

  List<Category> getAllCategories() {
    return quickInputs[userId];
  }

  Future initStartQuickInputs() async {
    await addDefaultQuickInput(quickInputs[userId][0], 0);
    await addDefaultQuickInput(quickInputs[userId][1], 1);
    await addDefaultQuickInput(quickInputs[userId][2], 2);
    return true;
  }

  Future addDefaultQuickInput(Category category, int categoryId) async {
    await quickInputCollection
        .doc(categoryId.toString())
        .set(category.toMap());
    return true;
  }

  Future updateQuickInput(Category category, String categoryId, int categoryNo) async {
    String previousCategoryId = int.parse(quickInputs[userId][categoryNo].categoryId).toString();
    await quickInputCollection
        .doc(previousCategoryId)
        .delete();
    await quickInputCollection
        .doc(int.parse(categoryId).toString())
        .set(category.toMap());
    quickInputs[userId][categoryNo] = category;
    return true;
  }

}