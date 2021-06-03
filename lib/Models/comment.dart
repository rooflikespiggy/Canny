import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {

  String uid;
  String did;
  String name;
  String description;
  DateTime datetime = DateTime.now();
  int likes = 0;
  int dislikes = 0;
  List liked_uid = [];
  List disliked_uid = [];

  Comment({
    this.uid,
    this.did,
    this.name,
    this.description,
    this.datetime,
    this.likes,
    this.dislikes,
    this.liked_uid,
    this.disliked_uid
  });

  Comment.fromMap(Map<String, dynamic> json) {
    uid = json['uid'];
    did = json['did'];
    name = json['name'];
    description = json['description'];
    datetime = json['datetime'];
    likes = json['likes'];
    dislikes = json['dislikes'];
    liked_uid = json['liked_uid'];
    disliked_uid = json['disliked_uid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'did': did,
      'name': name,
      'description': description,
      'datetime': DateTime.now(),
      'likes': 0,
      'dislikes': 0,
      'liked_uid': [],
      'disliked_uid': []
    };
  }
}