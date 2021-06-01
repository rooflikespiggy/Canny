import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Services/Quick Input/default_quickinputs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuickInputDatabaseService {
  final String uid;

  // collection reference
  final CollectionReference quickInputCollection = Database().quickInputDatabase();
  List<Category> categories = defaultQuickInputs;

  QuickInputDatabaseService({this.uid});

  Category getCategory(String categoryId) {
    return categories[int.parse(categoryId)];
  }

  Category getSpecificCategory(int categoryNo) {
    return categories[categoryNo];
  }

  List<Category> getAllCategories() {
    return categories;
  }

  Future initStartQuickInputs() async {
    await addDefaultQuickInput(categories[0], 0);
    await addDefaultQuickInput(categories[1], 1);
    await addDefaultQuickInput(categories[2], 2);
    return true;
  }

  Future addDefaultQuickInput(Category category, int categoryId) async {
    await quickInputCollection
        .doc(categoryId.toString())
        .set(category.toMap());
    return true;
  }

  Future updateQuickInput(Category category, String categoryId, int categoryNo) async {
    String previousCategoryId = int.parse(categories[categoryNo].categoryId).toString();
    await quickInputCollection
        .doc(previousCategoryId)
        .delete();
    await quickInputCollection
        .doc(int.parse(categoryId).toString())
        .set(category.toMap());
    categories[categoryNo] = category;
    return true;
  }

}