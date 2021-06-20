import 'package:Canny/Database/all_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Screens/Forum/forum_detail_screen.dart';

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
    List listToShow;

    // List<String> descriptionList = ForumSearchData().getDescriptionData(query);

    return StreamBuilder(
      stream: forumCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List data = [];
          for (int i = 0; i < snapshot.data.docs.length; i++) {
            data.add(snapshot.data.docs[i]);
          }
          if (query.isNotEmpty) {
            listToShow = data.where((doc) =>
                (doc['title'].toLowerCase().contains(query.toLowerCase()) &&
                doc['title'].toLowerCase().startsWith(query.toLowerCase())) ||
                doc['title'].toLowerCase().contains(query.toLowerCase())).toList();
          } else {
            listToShow = data;
          }
          return ListView.builder(
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listToShow.length,
            itemBuilder: (BuildContext context, int index) {
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
                            listToShow[index]['title'],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                    ForumDetailScreen(inputId: listToShow[index].id)));
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

