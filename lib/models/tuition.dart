import 'package:cloud_firestore/cloud_firestore.dart';

class Tuition{
  
  final bool isPremium;
  final bool isOnline;
  final String category;
  final String level;
  final String name;
  final String tutor;
  final String description;
  final String locality;
  final DocumentReference tutorRef;
  final double latitude;
  final double longitude;

  Tuition({this.isPremium, this.isOnline, this.category, this.level, this.name, this.tutor, this.tutorRef, this.latitude, this.longitude, this.description, this.locality});
}