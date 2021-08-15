import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class UploadImage {
  static Future<String> upload({
    @required File imageToUpload,
    @required String imageCategory,
  }) async {
    var imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    final firebase_storage.Reference firebaseStorageRef = FirebaseStorage
        .instance
        .ref()
        .child(imageCategory)
        .child(imageFileName);

    String uploadTaskToDownloadUrl = await firebaseStorageRef
        .putFile(imageToUpload)
        .then((taskSnapshot) async {
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    }).catchError((onError) => null);
    ;

    //StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    //String downloadUrl = await storageSnapshot.ref.getDownloadURL();

    // if (uploadTask.isComplete) {
    //   var url = downloadUrl.toString();
    //   return url;
    // }

    return uploadTaskToDownloadUrl;
  }
}
