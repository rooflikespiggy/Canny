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
  });

  Forum.fromMap(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    title = json['title'];
    description = json['description'];
    datetime = json['timestamp'];
    likes = json['likes'];
    liked_uid = json['liked_uid'];
    comments = json['comments'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'title': title,
      'description': description,
      'timestamp': datetime,
      'likes': likes,
      'liked_uid': liked_uid,
      'comments': comments
    };
  }
}