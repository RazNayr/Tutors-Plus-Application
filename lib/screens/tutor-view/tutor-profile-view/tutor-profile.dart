import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorsplus/models/tutor.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/screens/tutor-view/tutor-profile-view/tutor-actions/add-tuition-view.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/loading.dart';
import 'package:tutorsplus/shared/transition-animations.dart';

import 'tutor-actions/analytics-view.dart';
import 'tutor-actions/edit-profile-view.dart';

class TutorProfile extends StatefulWidget {
  @override
  _TutorProfileState createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile> {

  void _alertDialogMaxTuition(BuildContext context) {
    var alert = AlertDialog(
      title: Text("You have reached your tuition limit.",
        style: TextStyle(color: greyPlus, fontWeight: FontWeight.bold),
      ),
      backgroundColor: whitePlus,
      content: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
          children: [
            TextSpan(text: "Upgrade to "),
            TextSpan(text: "Premium now", style: TextStyle(color: purplePlus)),
            TextSpan(text: "!"),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context), 
          child: Text("No",
            style: TextStyle(
              fontSize: 16,
              color: greyPlus,
              fontWeight: FontWeight.bold
            ),
          )
        ),
        FlatButton(
          onPressed: null, 
          child: Text("Yes",
            style: TextStyle(
              fontSize: 16,
              color: purplePlus,
              fontWeight: FontWeight.bold
            ),
          )
        ),
      ],
      //shape: CircleBorder(),
      elevation: 20.0,
    );

    showDialog(
      context: context, 
      builder: (BuildContext context) => alert,
      barrierDismissible: true,
    );
  }

  void _alertDialogPremiumFeature(BuildContext context) {
    var alert = AlertDialog(
      title: Text("Oops!\nYou found a premium feature",
        style: TextStyle(color: greyPlus, fontWeight: FontWeight.bold),
      ),
      backgroundColor: whitePlus,
      content: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
          children: [
            TextSpan(text: "Upgrade to "),
            TextSpan(text: "Premium now", style: TextStyle(color: purplePlus)),
            TextSpan(text: "!"),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context), 
          child: Text("No",
            style: TextStyle(
              fontSize: 16,
              color: greyPlus,
              fontWeight: FontWeight.bold
            ),
          )
        ),
        FlatButton(
          onPressed: null, 
          child: Text("Yes",
            style: TextStyle(
              fontSize: 16,
              color: purplePlus,
              fontWeight: FontWeight.bold
            ),
          )
        ),
      ],
      //shape: CircleBorder(),
      elevation: 20.0,
    );

    showDialog(
      context: context, 
      builder: (BuildContext context) => alert,
      barrierDismissible: true,
    );
  }

  Widget _toggleNewTuitionIcon(tutordata){

    final tutorData = tutordata;

    if(tutorData.tuition.length >= 3){
      if(tutorData.isPremium){
        return null;
      }else{
        return Icon(Icons.lock);
      }
    }else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    return StreamBuilder<TutorData>(
      stream: DatabaseService(uid: user.uid).tutorData,
      builder: (context, snapshot){
        if(snapshot.hasData){
          TutorData tutorData = snapshot.data;

          return Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: orangePlus,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/tutor.png')
                    ),
                  ),
                ),

                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Text(
                    "Upgrade to Premium",
                    style: TextStyle(color: greyPlus, fontSize: 20)),
                  leading: Icon(Icons.multiline_chart),
                  onTap: () {
                    
                  }
                ),
                
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Text(
                    "Edit Tutor Profile",
                    style: TextStyle(color: greyPlus, fontSize: 20)),
                  leading: Icon(Icons.person_outline),
                  onTap: () {
                    Navigator.push(context, SlideToRoute(page: EditTutorProfile(tutorData: tutorData),type: "right"));
                  }
                ),

                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Text(
                    "View Public Profile",
                    style: TextStyle(color: greyPlus, fontSize: 20)),
                  leading: Icon(Icons.insert_emoticon),
                  onTap: () {
                    
                  }
                ),

                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Text(
                    "Add Tuition",
                    style: TextStyle(color: greyPlus, fontSize: 20)),
                  leading: Icon(Icons.library_add),
                  trailing: _toggleNewTuitionIcon(tutorData),
                  onTap: () {
                    if(tutorData.tuition.length >= 3){
                      if(tutorData.isPremium){
                        Navigator.push(context, SlideToRoute(page: AddTuition(tutorData: tutorData),type: "right"));
                      }else{
                        _alertDialogMaxTuition(context);
                      }
                    }else{
                      Navigator.push(context, SlideToRoute(page: AddTuition(tutorData: tutorData),type: "right"));
                    }
                  }
                ),

                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Text(
                    "Your Tuition",
                    style: TextStyle(color: greyPlus, fontSize: 20)),
                  leading: Icon(Icons.format_list_bulleted),
                  onTap: () {
                    
                  }
                ),

                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Text(
                    "View Analytics",
                    style: TextStyle(color: greyPlus, fontSize: 20)),
                  leading: Icon(Icons.insert_chart),
                  trailing: tutorData.isPremium? null: Icon(Icons.lock),
                  onTap: () {
                    if(tutorData.isPremium){
                      Navigator.push(context, SlideToRoute(page: Analytics(tutorData: tutorData),type: "right"));
                    }else{
                      _alertDialogPremiumFeature(context);
                    }
                  }
                ),

              ],
            ),
          );

        }else{
          return Loading();
        }
      }
    );
  }
}