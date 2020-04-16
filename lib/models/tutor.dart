import 'package:cloud_firestore/cloud_firestore.dart';

class Tutor{

  final String fname;
  final String lname;
  final String bio;

  final Timestamp dob;

  final bool isOnline;
  final bool isPremium;
  final bool isWarranted;

  final int rating;

  final List<Map> remarks;
  final List<Map> tuition;
  final List<String> qualifications;
  final List<DocumentReference> students;

  final Map analytics;

  Tutor({this.fname, this.lname, this.bio, this.dob, this.isOnline, this.isPremium, this.isWarranted, this.rating, this.remarks, this.tuition, this.qualifications, this.students, this.analytics});

}