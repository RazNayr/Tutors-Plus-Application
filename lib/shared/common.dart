import 'package:flutter/material.dart';

const whitePlus = Color(0xfffffbf7);
const greyPlus = Color(0xff757575);
const blackPlus = Color(0xff2c384a);
const yellowPlus = Color(0xffffca2b);
const amberPlus = Color(0xffffa714);
const orangePlus = Color(0xfff5820c);
const purplePlus = Color(0xff7e57c2);

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  // enabledBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Colors.white, width: 2.0),
  // ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: purplePlus, width: 2.0),
  ),
);