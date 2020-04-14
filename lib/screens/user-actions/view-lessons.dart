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
        backgroundColor: blackPlus,
        elevation: 0.0,
      ),

      body: StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            final lessons = snapshot.data.lessons ?? [];

            return ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                return LessonTile(lesson: lessons[index]);
              }
            );

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

    final lessonTitle = lesson['tuition_title'];
    final lessonCategory = lesson['tuition_category'];
    final lessonLevel = lesson['tuition_level'];
    final lessonTutor = lesson['tuition_tutor'];
    final lessonRef = lesson['tuition_ref'];


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
          title: Text(lessonTitle),
          subtitle: Text('Subject: '+ lessonCategory +'\nLevel: '+ lessonLevel),
          trailing: Icon(Icons.info),
          isThreeLine: true
        ),
      ),
    );
  }
}