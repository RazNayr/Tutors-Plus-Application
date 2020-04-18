import 'package:flutter/material.dart';
import 'package:tutorsplus/models/tutor.dart';

class Analytics extends StatefulWidget {

  final TutorData tutorData;
  Analytics({this.tutorData});
  
  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}