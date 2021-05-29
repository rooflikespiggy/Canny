import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Sidebar/View%20Categories/default_categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryDatabaseService {

  final String uid;
  // collection reference
  final CollectionReference categoryCollection = FirebaseFirestore.instance.collection('Users');
  List<Category> categories = defaultCategories;

  CategoryDatabaseService({this.uid});

  Future initStartCategories() async {
    for (int i = 0; i < categories.length; i++) {
      await categoryCollection
          .doc(uid)
          .collection("Categories")
          .add(categories[i].toMap());
    }
    return true;
  }

  /*
  Future updateUserData(List<Map<String, String>> defaultCategories) async {
    return await categoryCollection.doc(uid).set({
      'Food and Drink': defaultCategories[0],
      'Transportation': defaultCategories[1],
      'Shopping': defaultCategories[2],
      'Entertainment': defaultCategories[3],
      'Bills and Fees': defaultCategories[4],
      'Education': defaultCategories[5],
      'Gift': defaultCategories[6],
      'Household': defaultCategories[7],
      'Allowance': defaultCategories[8],
      'Salary': defaultCategories[9],
      'Loan': defaultCategories[10],
      'Other': defaultCategories[11],
    });
  }
   */

  //get categories stream
  Stream<QuerySnapshot> get getCategories {
    return categoryCollection.snapshots();
    //.map(_categoryFromSnapshot);
  }

}
