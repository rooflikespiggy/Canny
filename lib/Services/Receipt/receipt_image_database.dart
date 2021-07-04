/*
import 'dart:html';

import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/expense.dart';
import 'package:Canny/Models/receipt_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class ReceiptDatabaseService {
  final String uid;
  final FirebaseStorage _storage =
  FirebaseStorage.instanceFor(bucket: 'gs://canny-1088f.appspot.com');

  ReceiptDatabaseService({this.uid});

  Future<String> addReceiptURL(ReceiptImage receiptImage) async {
    File image = File([], receiptImage.imagePath);

    // Upload to Firebase
    String cloudFilePath = 'receipts/$uid/${receiptImage.uid}.png';
    Reference storageReference = _storage.ref().child(cloudFilePath);
    UploadTask _uploadTask;

    _uploadTask = storageReference.putFile(image);
    TaskSnapshot taskSnapshot = await _uploadTask.onComplete;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    // Delete local cache
    image.delete();

    return downloadURL;
  }

  /// Clear the image from Cloud Firestore when the user
  /// delete the image or delete the record.
  Future<void> deleteCloudImage(ReceiptImage receiptImage) async {
    if (receiptImage.hasCloudImage) {
      String cloudFilePath = 'receipts/$uid/${receiptImage.uid}.png';
      Reference storageReference = _storage.ref().child(cloudFilePath);
      storageReference.delete();
    }
  }
}
 */