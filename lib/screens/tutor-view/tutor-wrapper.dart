import 'package:flutter/material.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/screens/tutor-view/welcome-tutor.dart';

import 'become-tutor.dart';
import 'tutor-profile-view/tutor-profile.dart';

class TutorWrapper extends StatefulWidget {

  final UserData userData;

  TutorWrapper({this.userData});

  @override
  _TutorWrapperState createState() => _TutorWrapperState();
}

class _TutorWrapperState extends State<TutorWrapper> {

  bool showTutorWelcome = false;

  void toggleTutorWelcome(){
    setState(() => showTutorWelcome = !showTutorWelcome);
  }

  @override
  Widget build(BuildContext context) {

    if(widget.userData.isTutor && !showTutorWelcome){
      return TutorProfile();
    }else{
      if(showTutorWelcome){
        return WelcomeTutor(toggleWelcomeView: toggleTutorWelcome);
      }else{
        return BecomeTutor(toggleWelcomeView: toggleTutorWelcome);
      }
    }
  }
}