import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_todo_app/screens/create_note_screen.dart';
import 'package:flutter_firebase_todo_app/utils/custom_colors.dart';
import 'package:flutter_firebase_todo_app/utils/database_helper.dart';
import 'package:flutter_firebase_todo_app/utils/modals/note_modal.dart';
import 'package:get/get.dart';

enum NoteQuery { titleAsc, titleDesc, dateAsc, dateDesc }

extension on Query<Note> {
  /// Create a firebase query from a [NoteQuery]
  Query<Note> queryBy(NoteQuery query) {
    switch (query) {
      case NoteQuery.titleAsc:
      case NoteQuery.titleDesc:
        return orderBy('title', descending: query == NoteQuery.titleDesc);
      case NoteQuery.dateAsc:
      case NoteQuery.dateDesc:
        return orderBy('dateTime', descending: query == NoteQuery.dateDesc);
    }
  }
}



class MyNotes extends StatefulWidget {
  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {

  Stream<QuerySnapshot<Note>> _notes;

  Query<Note> _notesQuery;


  void _updateNotesQuery(NoteQuery query) {
    setState(() {
      Database.updateNoteref(FirebaseAuth.instance.currentUser.uid);
      _notesQuery = Database.notesRef.queryBy(query);
      _notes = _notesQuery.snapshots();

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateNotesQuery(NoteQuery.dateAsc);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[

          PopupMenuButton<NoteQuery>(
            onSelected: _updateNotesQuery,
            icon: const Icon(Icons.sort),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: NoteQuery.titleAsc,
                  child: Text('Sort by Title ascending'),
                ),
                const PopupMenuItem(
                  value: NoteQuery.titleDesc,
                  child: Text('Sort by Title descending'),
                ),
                const PopupMenuItem(
                  value: NoteQuery.dateAsc,
                  child: Text('Sort by Date ascending'),
                ),
                const PopupMenuItem(
                  value: NoteQuery.dateDesc,
                  child: Text('Sort by Date descending'),
                ),
              ];
            },
          ),

        ]
      ),
      body: Column(children: <Widget>[

        Expanded(
          child: Container(
            child: StreamBuilder<QuerySnapshot<Note>>(
              stream: _notes,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Note>> snapshot) {
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
                        CustomColors.firebaseOrange,
                      )),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return snapshot.data.docs.length!=null?
                        Dismissible(
                          key: Key(snapshot.data.docs[index].id),
                          background:
                          Container(color: Theme.of(context).primaryColor),
                          onDismissed: (direction) {
                            Database.deleteNoteById(
                                snapshot.data.docs[index].id);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Note dismissed')));
                          },
                          child: Card(
                            color: Colors.white10,
                            child: ListTile(
                              title: Text(snapshot.data.docs[index].data().title,
                                style: TextStyle(color: Colors.white),),
                              onTap: () async {
                                DocumentReference doc_ref = Database.notesRef
                                    .doc(snapshot.data.docs[index].id);
                                DocumentSnapshot<Note> docSnap =
                                await doc_ref.get();
                                Get.to(CreateNote(document: docSnap));
                              },
                            ),
                          ),
                        ):Text('No data');
                      });
                }
              },
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.firebaseOrange,
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(CreateNote());
        },
      ),
    );
  }
}























//
// body: FutureBuilder<List<QueryDocumentSnapshot<Note>>>(
// future: Database.fetchNotes(),
// builder: (BuildContext context,
//     AsyncSnapshot<List<QueryDocumentSnapshot<Note>>> snapshot) {
// if (snapshot.hasError) {
// return Text('Something went wrong');
// }
//
// if (snapshot.connectionState == ConnectionState.waiting) {
// return Text("Loading");
// } else {
// return ListView.builder(
// itemCount: snapshot.data.length,
// itemBuilder: (BuildContext ctxt, int index) {
// return ListTile(
// title: Text(snapshot.data[index].data().title),
// onTap: () async {
// DocumentReference doc_ref = Database.notesRef.doc(snapshot.data[index].id);
// DocumentSnapshot<Note> docSnap = await doc_ref.get();
//
// Get.to(CreateNote(document:docSnap));
// },
// );
// });
// }
// },
// ),
