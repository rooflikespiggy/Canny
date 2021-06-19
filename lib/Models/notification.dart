import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  bool notificationStatus;

  Notification({this.notificationStatus});

  factory Notification.fromMap(DocumentSnapshot doc) {
    Map json = doc.data();

    return Notification(
      notificationStatus: json['notificationStatus'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationStatus': notificationStatus,
    };
  }
}