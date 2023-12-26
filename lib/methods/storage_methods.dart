import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, String uid,
      [bool isFeed = false]) async {
    //This is the profile image storage method...................
    try {
      Reference ref = FirebaseStorage.instance.ref(childName).child(uid);
      if (isFeed) {
        String id = Uuid().v1();
        ref = ref.child(id);
      }
      UploadTask uploadTask = ref.putData(file);

      TaskSnapshot snap = await uploadTask;

      String downloadUrl = await snap.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return 'error occur in image';
    }
  }

  Future<String> uploadVideoToStorage(String childName, File file,
      [bool isFeed = false]) async {
    //This is the profile video storage method...................
    try {
      Reference ref = await FirebaseStorage.instance
          .ref()
          .child(childName)
          .child('video')
          .child("3Luc9mg59BOtNnYcxXQTbK9KHxH2");
      if (isFeed) {
        String id = Uuid().v1();
        ref = ref.child(id);
      }
      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot snap = await uploadTask;

      String downloadUrl = await snap.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return 'error occur in video';
    }
  }
}
