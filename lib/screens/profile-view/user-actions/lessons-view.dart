import 'package:flutter/material.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/screens/search-view/selected-tutor.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/transition-animations.dart';

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
          elevation: 4.0,
          centerTitle: true,
        ),

        body: ListView.builder(
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            return LessonTile(lesson: lessons[index], userData: userData);
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
  final UserData userData;
  LessonTile({ this.lesson, this.userData });

  
  void _alertDialogTuitionInfo(BuildContext context, tuitionName, tuitionTutor, tuitionDescription, tuitionIsPremium, tutorRef) {

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
            TextSpan(text: "\n\n"),
            TextSpan(text: tuitionDescription,
              style: TextStyle(fontSize: 14)
            ),
          ],
        ),
      ),
      actions: <Widget>[
        GestureDetector(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("Leave",
                style: TextStyle(
                  color: amberPlus
                )
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            _alertDialogConfirmLeave(context: context);
          },
        ),
        IconButton(
          icon: Icon(Icons.person_pin), 
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, ScaleToRoute(page: SelectedTutorProfile(tutorRef: tutorRef)));
          }
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

  void _alertDialogConfirmLeave({BuildContext context}) {

    final tuitionName = lesson['tuition_name'];
    final tutorRef = lesson['tuition_tutorRef'];

    var alert = AlertDialog(
      backgroundColor: whitePlus,
      content: Text("Are you sure you want to stop in the selected tuition?",
        style: TextStyle(fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("No",
              style: TextStyle(
                color: greyPlus,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ), 
            )
          ),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("Yes",
              style: TextStyle(
                color: yellowPlus,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ), 
            )
          ),
          onTap: (){
            Navigator.pop(context);
            DatabaseService(uid:userData.uid).cancelLesson(tuitionName, tutorRef);
            Navigator.pop(context);
          },
        ),
      ],
      elevation: 20.0,
  );

  showDialog(
    context: context, 
    builder: (BuildContext context) => alert,
    barrierDismissible: false,
  );
}

  @override
  Widget build(BuildContext context) {

    final tuitionName = lesson['tuition_name'];
    final tuitionCategory = lesson['tuition_category'];
    final tuitionLevel = lesson['tuition_level'];
    final tuitionTutor = lesson['tuition_tutor'];
    final tuitionDescription = lesson['tuition_description'];
    final tutorRef = lesson['tuition_tutorRef'];
    final tuitionIsPremium = lesson['tuition_isPremium'];


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
          trailing: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Icon(Icons.info, size: 30),
                onTap: (){
                  _alertDialogTuitionInfo(context, tuitionName, tuitionTutor, tuitionDescription, tuitionIsPremium, tutorRef);
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