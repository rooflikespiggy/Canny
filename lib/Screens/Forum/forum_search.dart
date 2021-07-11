import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Shared/custom_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Screens/Forum/forum_detail_screen.dart';
import 'package:page_transition/page_transition.dart';


class ForumSearch extends SearchDelegate {
  CollectionReference forumCollection = Database().forumDatabase();

  @override
  String get searchFieldLabel => "Search Forum";

  @override
  // TODO: no idea how to change the theme
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: theme.appBarTheme.copyWith(backgroundColor: kDarkBlue),  // appbar background color
      primaryColor: kDarkBlue,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white, // cursor color
      ),
      hintColor: Colors.white, //hint text color
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white), // icons color
      primaryColorBrightness: Brightness.dark,
      fontFamily: 'Lato-Thin',
      textTheme: theme.textTheme.copyWith(
        headline6: TextStyle(
            fontFamily: 'Lato-Thin',
            fontWeight: FontWeight.normal,
            color: Colors.white
        ),  // query Color
      ),
    );
  }

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
                          contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                          title: Text(
                            listToShow[index]['title'],
                            style: TextStyle(
                              fontFamily: 'Lato-Thin',
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ForumDetailScreen(inputId: listToShow[index].id))
                            );
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

