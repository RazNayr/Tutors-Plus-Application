import 'package:flutter/material.dart';
import 'package:tutorsplus/models/user.dart';

class Messenger extends StatefulWidget {

  final UserData userData;

  Messenger({this.userData});

  @override
  _MessengerState createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}