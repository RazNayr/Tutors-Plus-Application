import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/loading.dart';

class UserLessons extends StatefulWidget {
  @override
  _UserLessonsState createState() => _UserLessonsState();
}

class _UserLessonsState extends State<UserLessons> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: amberPlus,
        title: Text("Your Lessons"),
        elevation: 0.0,
      ),

      body: StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            final lessons = snapshot.data.lessons ?? [];

            if(lessons.length != 0){
              return ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  return LessonTile(lesson: lessons[index]);
                }
              );
            }else{
              return Container(
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
              );
            }
            

          }else{
            return Loading();
          }
        }
      ),
    );
  }
}

class LessonTile extends StatelessWidget {

  final Map lesson;
  LessonTile({ this.lesson });

  @override
  Widget build(BuildContext context) {

    final tuitionTitle = lesson['tuition_title'];
    final tuitionCategory = lesson['tuition_category'];
    final tuitionLevel = lesson['tuition_level'];
    //final tuitionTutor = lesson['tuition_tutor'];
    //final tuitionRef = lesson['tuition_ref'];


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
          title: Text(tuitionTitle),
          subtitle: Text('Subject: '+ tuitionCategory +'\nLevel: '+ tuitionLevel),
          trailing: Icon(Icons.info),
          isThreeLine: true
        ),
      ),
    );
  }
}