import 'package:flutter/material.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/shared/common.dart';

class UserLessons extends StatefulWidget {

  final UserData userData;

  UserLessons({this.userData});

  @override
  _UserLessonsState createState() => _UserLessonsState();
}

class _UserLessonsState extends State<UserLessons> {
  @override
  Widget build(BuildContext context) {

    final UserData userData = widget.userData;
    final lessons = userData.lessons ?? [];

    if(lessons.length != 0){

      return Scaffold(
        appBar: AppBar(
          backgroundColor: amberPlus,
          title: Text("Your Lessons"),
          elevation: 0.0,
        ),

        body: ListView.builder(
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            return LessonTile(lesson: lessons[index]);
          }
        ),
  
      );

    }else{
      
      return Scaffold(
        appBar: AppBar(
          backgroundColor: amberPlus,
          title: Text("Your Lessons"),
          elevation: 0.0,
        ),

        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.sentiment_dissatisfied, size: 70,),
              SizedBox(height: 20),
              Card(
                margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text("You have not enrolled in any tuition yet!",
                    style: TextStyle(
                      fontSize: 17, 
                      fontWeight: FontWeight.bold, 
                      fontFamily: "OpenSans"
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      );

    }
  }
}

class LessonTile extends StatelessWidget {

  final Map lesson;
  LessonTile({ this.lesson });

  
  void _alertDialogTuitionInfo(BuildContext context, tuitionName, tuitionTutor, tuitionDescription, tuitionIsPremium, tuitionIsOnline) {

    var alert = AlertDialog(
      title: Text(tuitionName,
        style: TextStyle(color: greyPlus, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      backgroundColor: whitePlus,
      content: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
          children: [
            TextSpan(text: "Tutor: "),
            TextSpan(text: tuitionTutor, 
              style: tuitionIsPremium ? TextStyle(color: purplePlus) : TextStyle(color: orangePlus) ),
            TextSpan(text: "\n"),
            TextSpan(text: tuitionDescription,
              style: TextStyle(fontSize: 14)
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Icon( tuitionIsOnline? Icons.headset_mic : Icons.headset_off),
        IconButton(
          icon: Icon(Icons.person_pin), 
          onPressed: () => Navigator.pop(context)
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

    final tuitionName = lesson['tuition_name'];
    final tuitionCategory = lesson['tuition_category'];
    final tuitionLevel = lesson['tuition_level'];
    final tuitionTutor = lesson['tuition_tutor'];
    final tuitionDescription = lesson['tuition_description'];
    //final tuitionRef = lesson['tuition_ref'];
    final tuitionIsPremium = lesson['tuition_isPremium'];
    final tuitionIsOnline = lesson['tuition_isOnline'];


    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/book.png'),
          ),
          title: Text(tuitionName),
          subtitle: Text('Subject: '+ tuitionCategory +'\nLevel: '+ tuitionLevel),
          trailing: GestureDetector(
            child: Icon(Icons.info,),
            onTap: (){
              _alertDialogTuitionInfo(context, tuitionName, tuitionTutor, tuitionDescription, tuitionIsPremium, tuitionIsOnline);
            },
          ),
          isThreeLine: true
        ),
      ),
    );
  }
}