import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_todo_app/utils/database_helper.dart';
import 'package:flutter_firebase_todo_app/utils/modals/note_modal.dart';
import 'package:get/get.dart';

class CreateNote extends StatelessWidget {

  DocumentSnapshot<Note> document;
  CreateNote({this.document});

  @override
  Widget build(BuildContext context) {

    String text="";
    text=document==null?"":document.data().title;
    TextEditingController textEditingController = new TextEditingController(text: text);



    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                title: document==null?Text('Create a New Note '):Text('Update note')
            ),
            body: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Create a new note!!',
                          labelText: ' My Note',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black87),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              var uid = Database.user.uid;
                              var datetime = DateTime.now();
                              Timestamp myTimeStamp =
                                  Timestamp.fromDate(datetime);
                              if (document == null) {
                                Database.addNote(
                                    Note(
                                        title: textEditingController.text,
                                        uid: uid,
                                        dateTime: myTimeStamp),
                                    context);
                              } else {
                                Database.updateNoteById(
                                    document.id,
                                    Note(
                                        title: textEditingController.text,
                                        dateTime: myTimeStamp));
                              }
                              Get.back();
                            },
                            child:
                                document == null ? Text('Add') : Text('Update'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green, elevation: 2),
                          )
                        ])
                  ],
                ),
              ),
            )));
  }
}
