import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/screens/authentication/authenticate.dart';
import 'package:tutorsplus/screens/homepage/homepage.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    if(user == null){
      return Authenticate();
    }else{
      return Homepage();
    }
  }
}