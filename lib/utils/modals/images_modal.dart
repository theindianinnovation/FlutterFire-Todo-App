import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Images {
  Images({@required this.url,this.uid,this.dateTime});
  final String url;
  final String uid;
  final Timestamp dateTime;

  Images.fromJson(Map<String, Object> json)
      : this(
      url: json['url'] as String,
      uid: json['uid'] as String,
      dateTime :json['dateTime'] as Timestamp

  );

  Map<String, Object> toJson() {
    return {
      'url': url,
      'uid' : uid,
      'dateTime' :dateTime
    };
  }
}