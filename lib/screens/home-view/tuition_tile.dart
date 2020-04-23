import 'package:flutter/material.dart';
import 'package:tutorsplus/models/tuition.dart';
import 'package:tutorsplus/screens/search-view/selected-tutor.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/transition-animations.dart';

class TuitionTile extends StatelessWidget {
  TuitionTile({this.tuition,this.index});
  final Tuition tuition;
  final int index;
  
  void _alertDialogTuitionActions({BuildContext context}) {

    var alert = AlertDialog(
      title: Text(tuition.name,
        style: TextStyle(color: tuition.isPremium ? purplePlus : orangePlus, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      backgroundColor: whitePlus,
      content: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
          children: [
            TextSpan(text: "Description: \n"),
            TextSpan(text: tuition.description,
              style: TextStyle(fontSize: 14)
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon( tuition.isOnline? Icons.headset_mic : Icons.headset_off ),
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon( Icons.person ),
          ),
          onTap: (){
            Navigator.pop(context);
            Navigator.push(context, ScaleToRoute(page: SelectedTutorProfile(tutorRef: tuition.tutorRef)));
          },
        ),
      ],
      elevation: 20.0,
    );

    showDialog(
      context: context, 
      builder: (BuildContext context) => alert,
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: index!=1 ? const EdgeInsets.only(top: 8.0) : const EdgeInsets.only(top: 0.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/book.png'),
          ),
          title: Text(tuition.name,
            style: TextStyle(color: tuition.isPremium? purplePlus : orangePlus),
          ),
          subtitle: Text('Subject: '+ tuition.category +'\nLevel: '+ tuition.level),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Icon(Icons.info,),
                onTap: (){
                  _alertDialogTuitionActions(context: context);
                },
              ),
            ],
          ),
          isThreeLine: true
        ),
      ),
    );
  }
}