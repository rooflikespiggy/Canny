import 'package:cloud_firestore/cloud_firestore.dart';

class Forum {
  String uid;
  String name;
  String title;
  String description;
  DateTime datetime = DateTime.now();
  int likes = 0;
  List liked_uid = [];
  int comments = 0;

  Forum({
    this.uid,
    this.name,
    this.title,
    this.description,
    this.datetime,
    this.likes,
    this.liked_uid,
    this.comments
  });

  factory Forum.fromMap(DocumentSnapshot doc) {
    Map json = doc.data();

    return Forum(
        uid: json['uid'],
        name: json['name'],
        title: json['title'],
        description: json['description'],
        datetime: json['datetime'],
        likes: json['likes'],
        liked_uid: json['liked_uid'],
        comments: json['comments']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'title': title,
      'description': description,
      'datetime': DateTime.now(),
      'likes': 0,
      'liked_uid': [],
      'comments': 0
    };
  }
}