import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'file:///F:/APPLICATIONS/FLUTTER/flutter_firebase_todo_app/lib/utils/modals/images_modal.dart';
import 'package:flutter_firebase_todo_app/utils/storage_helper.dart';
import 'package:get/get.dart';

class UploadTaskListTile extends StatelessWidget {
  // ignore: public_member_api_docs
  UploadTaskListTile({
    Key key,
    this.task,
    this.docid
  }) : super(key: key);

  /// The [UploadTask].
  final Images /*!*/ task;
  final String docid;
  StorageController storage = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction)  {
         storage.deleteImage(task, context,docid.toString());
      },
      child: Card(
          child: Row(
            children: [
              Container(
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/google_logo.png',
                    image: task.url,
                    height: 150,
                    width: 150,
                  )),
              IconButton(
                  icon: Icon(Icons.download_sharp),
                  onPressed: () async {
                     storage.downloadFile(
                        task, context);
                  }),
              IconButton(
                  icon: Icon(Icons.link_outlined),
                  onPressed: () async {
                     storage.copyURL(
                       task, context);
                  }),
            ],
          )),
    );
  }

}


//
// /// Enum representing the upload task types the example app supports.
// enum UploadType {
//   string,
//   file,
//   clear,
// }
//
// /// A StatefulWidget which keeps track of the current uploaded files.
// class TaskManager extends StatefulWidget {
//   // ignore: public_member_api_docs
//   TaskManager({Key key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     return _TaskManager();
//   }
// }
//
// class _TaskManager extends State<TaskManager> {
//   List<UploadTask> _uploadTasks = [];
//   final Uuid _uuid=new Uuid();
//
//   /// The user selects a file, and the task is added to the list.
//   Future<UploadTask> uploadFile(PickedFile file) async {
//     if (file == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('No file was selected'),
//       ));
//       return null;
//     }
//
//     UploadTask uploadTask;
//
//     // Create a Reference to the file
//     Reference ref = FirebaseStorage.instance
//         .ref()
//         .child('playground').child('${FirebaseAuth.instance.currentUser.uid}')
//         .child('/${_uuid.v1()}.jpg');
//
//     final metadata = SettableMetadata(
//         contentType: 'image/jpeg',
//         customMetadata: {'picked-file-path': file.path});
//
//     if (kIsWeb) {
//       uploadTask = ref.putData(await file.readAsBytes(), metadata);
//     } else {
//       uploadTask = ref.putFile(io.File(file.path), metadata);
//     }
//
//     return Future.value(uploadTask);
//   }
//
//   /// A new string is uploaded to storage.
//   UploadTask uploadString() {
//     const String putStringText =
//         'This upload has been generated using the putString method! Check the metadata too!';
//
//     // Create a Reference to the file
//     Reference ref = FirebaseStorage.instance
//         .ref()
//         .child('playground').child('${FirebaseAuth.instance.currentUser.uid}')
//         .child('/put-string-example.txt');
//
//     // Start upload of putString
//     return ref.putString(putStringText,
//         metadata: SettableMetadata(
//             contentLanguage: 'en',
//             customMetadata: <String, String>{'example': 'putString'}));
//   }
//
//   /// Handles the user pressing the PopupMenuItem item.
//   Future<void> handleUploadType(UploadType type) async {
//     switch (type) {
//       case UploadType.string:
//         setState(() {
//           _uploadTasks = [..._uploadTasks, uploadString()];
//         });
//         break;
//       case UploadType.file:
//         PickedFile file =
//         await ImagePicker().getImage(source: ImageSource.gallery);
//         UploadTask task = await uploadFile(file);
//         if (task != null) {
//           setState(() {
//             _uploadTasks = [..._uploadTasks, task];
//           });
//         }
//         break;
//       case UploadType.clear:
//         setState(() {
//           _uploadTasks = [];
//         });
//         break;
//     }
//   }
//
//   void _removeTaskAtIndex(int index) {
//     setState(() {
//       _uploadTasks = _uploadTasks..removeAt(index);
//     });
//   }
//
//
//   Future<void> _downloadLink(Reference ref) async {
//     final link = await ref.getDownloadURL();
//
//     await Clipboard.setData(ClipboardData(
//       text: link,
//     ));
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text(
//           'Success!\n Copied download URL to Clipboard!',
//         ),
//       ),
//     );
//   }
//
//   Future<void> _downloadFile(Reference ref) async {
//     final io.Directory systemTempDir = io.Directory.systemTemp;
//     final io.File tempFile = io.File('${systemTempDir.path}/temp-${ref.name}');
//     if (tempFile.existsSync()) await tempFile.delete();
//
//     await ref.writeToFile(tempFile);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Success!\n Downloaded ${ref.name} \n from bucket: ${ref.bucket}\n '
//               'at path: ${ref.fullPath} \n'
//               'Wrote "${ref.fullPath}" to tmp-${ref.name}.txt',
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Storage Example App'),
//         actions: [
//           PopupMenuButton<UploadType>(
//             onSelected: handleUploadType,
//             icon: const Icon(Icons.add),
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 // ignore: sort_child_properties_last
//                   child: Text('Upload string'),
//                   value: UploadType.string),
//               const PopupMenuItem(
//                 // ignore: sort_child_properties_last
//                   child: Text('Upload local file'),
//                   value: UploadType.file),
//               if (_uploadTasks.isNotEmpty)
//                 const PopupMenuItem(
//                   // ignore: sort_child_properties_last
//                     child: Text('Clear list'),
//                     value: UploadType.clear)
//             ],
//           )
//         ],
//       ),
//       body: _uploadTasks.isEmpty
//           ? const Center(child: Text("Press the '+' button to add a new file.",style: TextStyle(color: Colors.white,),))
//           : ListView.builder(
//         itemCount: _uploadTasks.length,
//         itemBuilder: (context, index) => UploadTaskListTile(
//           task: _uploadTasks[index],
//           onDismissed: () => _removeTaskAtIndex(index),
//           onDownloadLink: () {
//             return _downloadLink(_uploadTasks[index].snapshot.ref);
//           },
//           onDownload: () {
//             if (kIsWeb) {
//               //return _downloadBytes(_uploadTasks[index].snapshot.ref);
//             } else {
//               return _downloadFile(_uploadTasks[index].snapshot.ref);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
//
// /// Displays the current state of a single UploadTask.
// class UploadTaskListTile extends StatelessWidget {
//   // ignore: public_member_api_docs
//   const UploadTaskListTile({
//     Key key,
//     this.task,
//     this.onDismissed,
//     this.onDownload,
//     this.onDownloadLink,
//   }) : super(key: key);
//
//   /// The [UploadTask].
//   final UploadTask /*!*/ task;
//
//   /// Triggered when the user dismisses the task from the list.
//   final VoidCallback /*!*/ onDismissed;
//
//   /// Triggered when the user presses the download button on a completed upload task.
//   final VoidCallback /*!*/ onDownload;
//
//   /// Triggered when the user presses the "link" button on a completed upload task.
//   final VoidCallback /*!*/ onDownloadLink;
//
//   /// Displays the current transferred bytes of the task.
//   String _bytesTransferred(TaskSnapshot snapshot) {
//     return '${snapshot.bytesTransferred}/${snapshot.totalBytes}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<TaskSnapshot>(
//       stream: task.snapshotEvents,
//       builder: (
//           BuildContext context,
//           AsyncSnapshot<TaskSnapshot> asyncSnapshot,
//           ) {
//         Widget subtitle = const Text('---',style: TextStyle(color: Colors.white,),);
//         TaskSnapshot snapshot = asyncSnapshot.data;
//         TaskState state = snapshot?.state;
//
//         if (asyncSnapshot.hasError) {
//           if (asyncSnapshot.error is firebase_core.FirebaseException &&
//               (asyncSnapshot.error as firebase_core.FirebaseException).code ==
//                   'canceled') {
//             subtitle = const Text('Upload canceled.');
//           } else {
//             // ignore: avoid_print
//             print(asyncSnapshot.error);
//             subtitle = const Text('Something went wrong.');
//           }
//         } else if (snapshot != null) {
//           subtitle = Text('$state: ${_bytesTransferred(snapshot)} bytes sent');
//         }
//
//         return Dismissible(
//           key: Key(task.hashCode.toString()),
//           onDismissed: ($) => onDismissed(),
//           child: ListTile(
//             title: Text('Upload Task #${task.hashCode}',style: TextStyle(color:Colors.white),),
//             subtitle: subtitle,
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 if (state == TaskState.running)
//                   IconButton(
//                     color: Colors.white,
//                     icon: const Icon(Icons.pause),
//                     onPressed: task.pause,
//                   ),
//                 if (state == TaskState.running)
//                   IconButton(
//                     color: Colors.white,
//                     icon: const Icon(Icons.cancel),
//                     onPressed: task.cancel,
//                   ),
//                 if (state == TaskState.paused)
//                   IconButton(
//                     color: Colors.white,
//                     icon: const Icon(Icons.file_upload),
//                     onPressed: task.resume,
//                   ),
//                 if (state == TaskState.success)
//                   IconButton(
//                     color: Colors.white,
//                     icon: const Icon(Icons.file_download),
//                     onPressed: onDownload,
//                   ),
//                 if (state == TaskState.success)
//                   IconButton(
//                     color: Colors.white,
//                     icon: const Icon(Icons.link),
//                     onPressed: onDownloadLink,
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
