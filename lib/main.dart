import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorsplus/screens/main-wrapper.dart';
import 'package:tutorsplus/services/auth.dart';
import 'package:tutorsplus/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: MainWrapper(),
      ),
    );
  }
}
