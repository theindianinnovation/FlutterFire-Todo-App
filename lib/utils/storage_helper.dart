import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'file:///F:/APPLICATIONS/FLUTTER/flutter_firebase_todo_app/lib/utils/modals/images_modal.dart';

class StorageController extends GetxController {
  final Reference storageReference = FirebaseStorage.instance
      .ref('playground')
      .child('${FirebaseAuth.instance.currentUser.uid}');

  User user = FirebaseAuth.instance.currentUser;

  void updateUserImages(String currentUser) {
   updateImageref(currentUser);

  }
  void updateImageref(String uid) {
    imagesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('images')
        .withConverter<Images>(
          fromFirestore: (snapshot, _) => Images.fromJson(snapshot.data()),
          toFirestore: (note, _) => note.toJson(),
        );
  }

  static var imagesRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('images')
      .withConverter<Images>(
        fromFirestore: (snapshot, _) => Images.fromJson(snapshot.data()),
        toFirestore: (note, _) => note.toJson(),
      );

  Stream<QuerySnapshot<Images>> images = imagesRef.snapshots();

  @override
  void onInit() {
    super.onInit();
  }

  Future<String> getImageURL(Reference ref) async {
    return await ref.getDownloadURL();
  }

  Future<void> copyURL(Images ref, BuildContext context) async {
    final link = await storageReference.child(ref.uid).getDownloadURL();
    return await Clipboard.setData(ClipboardData(
      text: link,
    )).then((value) => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Success!\n Copied download URL to Clipboard!',
        ),
      ),
    ));
  }

  Future<void> deleteImage(
      Images ref, BuildContext context, String documentId) async {
    return await
    storageReference.child(ref.uid).delete().then((val) {
      imagesRef.doc(documentId).delete().then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Success!\n Deleted Image from Storage',
          ),
        ));
      }).catchError((error) => print("Failed to delete image: $error"));
    });
  }

  // Future<void> deleteImageFromStorage(Reference ref,BuildContext context){
  //  return ref.delete().then((val) {
  //    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //      content: Text(
  //        'Success!\n Deleted Image from Storage',
  //      ),
  //    ));
  //  };
  // }

  Future<void> downloadFile(Images ref, BuildContext context) async {
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/temp-${storageReference.child(ref.uid).name}');
    if (tempFile.existsSync()) await tempFile.delete();

    return await storageReference.child(ref.uid).writeToFile(tempFile).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Success!\n Downloaded ${storageReference.child(ref.uid).name} \n from bucket: ${storageReference.child(ref.uid).bucket}\n '
                  'at path: ${storageReference.child(ref.uid).fullPath} \n'
                  'Wrote "${storageReference.child(ref.uid).fullPath}" to tmp-${storageReference.child(ref.uid).name}.txt',
            ),
      ));
    }).catchError((error) => print("Failed to delete image: $error"));

  }

  Future<void> uploadImage(File imagefile, BuildContext context) async {
    var uid = Uuid().v1();
    var datetime = DateTime.now();
    Timestamp myTimeStamp = Timestamp.fromDate(datetime);
    String linkURL = "";
    return await storageReference
        .child(uid)
        .putFile(imagefile)
        .then((val) async {
      linkURL = await getImageURL(val.ref);
      imagesRef
          .add(Images(uid: uid, dateTime: myTimeStamp, url: linkURL))
          .then((value) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Image Added in DB'))))
          .catchError((error) => print("Failed to add image in DB: $error"));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Image Uploaded Successfully')));
    });
  }

  Future<List<Reference>> fetchImages() async {
    ListResult result = await storageReference.listAll();
    List<Reference> urls = [];
    result.items.forEach((Reference ref) async {
      urls.add(ref);
    });
    return urls;
  }
}
