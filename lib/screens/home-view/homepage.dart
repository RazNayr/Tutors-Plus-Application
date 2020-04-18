import 'package:flutter/material.dart';
import 'package:tutorsplus/models/user.dart';

class Home extends StatefulWidget {

  final UserData userData;

  Home({this.userData});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}