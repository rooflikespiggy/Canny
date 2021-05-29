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
  });

  Comment.fromMap(Map<String, dynamic> json) {
    uid = json['uid'];
    did: json['did'];
    name = json['name'];
    description = json['description'];
    datetime = json['timestamp'];
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
      'timestamp': datetime,
      'likes': likes,
      'dislikes': dislikes,
      'liked_uid': liked_uid,
      'disliked_uid': disliked_uid
    };
  }
}