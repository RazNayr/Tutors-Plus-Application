import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/loading.dart';

import 'become-tutor.dart';
import 'tutor-profile-view/tutor-profile.dart';

class TutorWrapper extends StatefulWidget {
  @override
  _TutorWrapperState createState() => _TutorWrapperState();
}

class _TutorWrapperState extends State<TutorWrapper> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    return StreamBuilder<Object>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;

          if(userData.isTutor){
            return TutorProfile();
          }else{
            return BecomeTutor();
          }

        }else{
          return Loading();
        }
      }
    );
  }
}