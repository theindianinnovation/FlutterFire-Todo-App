import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Note {
  Note({@required this.title,this.uid,this.dateTime});
  final String title;
  final String uid;
  final Timestamp dateTime;

  Note.fromJson(Map<String, Object> json)
      : this(
    title: json['title'] as String,
    uid: json['uid'] as String,
      dateTime :json['dateTime'] as Timestamp

  );

  Map<String, Object> toJson() {
    return {
      'title': title,
      'uid' : uid,
      'dateTime' :dateTime
    };
  }
}