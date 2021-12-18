import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptImage {
  String receiptURL;
  String imagePath;
  bool hasCloudImage;
  String uid;

  ReceiptImage({
    this.receiptURL,
    this.imagePath,
    this.hasCloudImage,
    this.uid,
  });

  factory ReceiptImage.fromMap(DocumentSnapshot doc) {
    Map json = doc.data();

    return ReceiptImage(
      receiptURL: json['receiptURL'],
      imagePath: json['imagePath'],
      hasCloudImage: json['hasCloudImage'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'receiptURL': receiptURL,
      'imagePath': imagePath,
      'hasCloudImage': hasCloudImage,
      'uid': uid,
    };
  }
}