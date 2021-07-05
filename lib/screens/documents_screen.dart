import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_todo_app/custom_widgets/storage_file.dart';
import 'package:flutter_firebase_todo_app/utils/database_helper.dart';
import 'file:///F:/APPLICATIONS/FLUTTER/flutter_firebase_todo_app/lib/utils/modals/images_modal.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_firebase_todo_app/utils/storage_helper.dart';
import 'package:get/get.dart';

class DocumentsScreen extends StatefulWidget {
  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final StorageController storage = Get.put(StorageController());
  File _image;
  final picker = ImagePicker();

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  Stream<QuerySnapshot<Images>> _images;

  void _updateImagesQuery() {
    setState(() {
      storage.updateImageref(FirebaseAuth.instance.currentUser.uid);
      _images = StorageController.imagesRef.snapshots();

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _updateImagesQuery();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Expanded(
              child:Container(
                child: StreamBuilder<QuerySnapshot<Images>>(
                  stream: _images,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Images>> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Icon(
                          Icons.report_gmailerrorred_sharp,
                          size: 80,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          )),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return snapshot.data.docs.length!=null?
                           // Image.network(snapshot.data.docs[index].data().url,height:50 ,)
                           UploadTaskListTile(task: snapshot.data.docs[index].data(),docid: snapshot.data.docs[index].id,)
                            :Text('No data');
                          });
                    }
                  },
                ),
              ), )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.post_add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          await getImageGallery();
          if (_image != null) {
            await storage.uploadImage(_image, context);
          } else
            CircularProgressIndicator();
        },
      ),
    ));
  }
}

//
// FutureBuilder(
// future: storage.fetchImages(),
// builder: (BuildContext context,
//     AsyncSnapshot<List<Reference>> snapshot) {
// if (snapshot.hasError) {
// return Center(
// child: Icon(
// Icons.report_gmailerrorred_sharp,
// size: 80,
// color: Theme.of(context).primaryColor,
// ),
// );
// }
//
// else if (snapshot.connectionState == ConnectionState.waiting) {
// return Center(
// child: CircularProgressIndicator(
// valueColor: AlwaysStoppedAnimation<Color>(
// Theme.of(context).primaryColor,
// )),
// );
// } else {
// return ListView.builder(
// itemCount: snapshot.data.length,
// itemBuilder: (BuildContext ctxt, int index) {
// return snapshot.data.length != null
// ? UploadTaskListTile(task:snapshot.data[index],)
//     : Center(child: Icon(Icons.hourglass_empty,size:50,color: Theme.of(context).primaryColor,));
// });
// }
// })