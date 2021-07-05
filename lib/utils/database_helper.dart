import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'modals/note_modal.dart';

class Database {

  static User user=FirebaseAuth.instance.currentUser;

  static void updateNoteref (String uid){
    notesRef =
        FirebaseFirestore.instance.collection('users').doc(uid).collection('notes').withConverter<Note>(
          fromFirestore: (snapshot, _) => Note.fromJson(snapshot.data()),
          toFirestore: (note, _) => note.toJson(),
        );
  }
  static var notesRef =
      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('notes').withConverter<Note>(
            fromFirestore: (snapshot, _) => Note.fromJson(snapshot.data()),
            toFirestore: (note, _) => note.toJson(),
          );

  static Stream<QuerySnapshot<Note>> notes = notesRef.snapshots();

  static Future<void> addNote(Note data, BuildContext context) {
    // Call the user's CollectionReference to add a new user
    return notesRef
        .add(data)
        .then((value) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Note Added'))))
        .catchError((error) => print("Failed to add note: $error"));
  }

  static Future<void> deleteNoteById(String documentId) {
    return notesRef
        .doc(documentId)
        .delete()
        .then((value) => print("Note Deleted"))
        .catchError((error) => print("Failed to delete note: $error"));
  }

  static Future<void> updateNoteById(String documentId, Note note) {
    return notesRef
        .doc(documentId)
        .update({'title': note.title})
        .then((value) => print("Note Updated"))
        .catchError((error) => print("Failed to update note: $error"));
  }

  // static Future<List<QueryDocumentSnapshot<Note>>> fetchNotes() async {
  //   QuerySnapshot<Note> notes = await notesRef.get();
  //   _movies = notes.docs;
  //   return _movies;
  // }
}
