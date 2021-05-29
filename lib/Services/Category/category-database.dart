import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Canny/Models/category';

class CategoryDatabaseService {

  final String uid;
  CategoryDatabaseService({ this.uid });

  //collection reference
  final CollectionReference categoryCollection = FirebaseFirestore.instance.collection('Categories');
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

  //get categories stream
  Stream<QuerySnapshot> get categories{
    return categoryCollection.snapshots();
    //.map(_categoryFromSnapshot);
  }
}
