import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  final String uid;
  
  User({ this.uid });

}

class UserData {

  final String uid;
  final String fname;
  final String lname;
  final Timestamp dob;
  final bool isTutor;
  final List<String> preferences;
  final List<Map> favourites;
  final List<Map> lessons;

  UserData(this.uid, this.fname, this.lname, this.dob, {this.isTutor, this.preferences, this.favourites, this.lessons});

}