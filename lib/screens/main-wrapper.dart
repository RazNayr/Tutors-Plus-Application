import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/screens/authentication/authenticate.dart';
import 'package:tutorsplus/screens/page-wrapper.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/loading.dart';

class MainWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    if(user == null){
      return Authenticate();
    }else{
      return StreamBuilder<Object>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return PageWrapper(userData: snapshot.data);
          }else{
            return new Loading();
          }
          
        }
      );
    }
  }
}