import 'package:Canny/Database/all_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Database/get_forum_database.dart';
import 'package:Canny/Screens/Forum/forum_detail_screen.dart';
import 'package:firestore_search/firestore_search.dart';

class ForumSearch extends SearchDelegate {
  CollectionReference forumCollection = Database().forumDatabase();

  @override
  String get searchFieldLabel => "Search Forum";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        }
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> titleList = ForumSearchData().getTitleData(query);
    print('hi');
    // List<String> descriptionList = ForumSearchData().getDescriptionData(query);

    return StreamBuilder(
      stream: forumCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final snapshotData = snapshot.data.docs[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.all(5.0),
                          title: Text(
                            snapshotData['title'],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                    ForumDetailScreen(inputId: snapshotData.id)));
                          },
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }
        return CircularProgressIndicator();
      }
    );
  }
}

