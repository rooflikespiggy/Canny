import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'all_database.dart';

class ForumSearchData {
  CollectionReference forumCollection = Database().forumDatabase();
  List<String> titleList = [];
  List<String> descriptionList = [];

  Future getData() async {
    QuerySnapshot snapshot = await forumCollection.get();
    return snapshot.docs;
  }

  Future queryTitleData(String queryString) async {
    await forumCollection
        .where('title', isGreaterThanOrEqualTo: queryString)
        .get()
        .then((value) {
          value.docs.forEach((element) {
            titleList.add(element['title']);
          });
    });
  }

  List<String> getTitleData(String queryString) {
    queryTitleData(queryString);
    return titleList;
  }
}
