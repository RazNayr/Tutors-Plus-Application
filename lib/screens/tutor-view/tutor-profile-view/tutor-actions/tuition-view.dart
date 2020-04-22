import 'package:flutter/material.dart';
import 'package:tutorsplus/models/tutor.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/loading.dart';

class TutorTuition extends StatefulWidget {

  final TutorData tutorData;

  TutorTuition({this.tutorData});

  @override
  _TutorTuitionState createState() => _TutorTuitionState();
}

class _TutorTuitionState extends State<TutorTuition> {

  void _removeTuition({tuitionRef, tuitionIndex, tuitionName}) {
    setState(() async{
      await DatabaseService(uid: widget.tutorData.uid).removeTuition(tuitionRef,tuitionIndex,tuitionName);
    });
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<TutorData>(
      stream: DatabaseService(uid: widget.tutorData.uid).tutorData,
      builder: (context, snapshot) {

        if(snapshot.hasData){

          final TutorData tutorData = snapshot.data;
          final tuitions = tutorData.tuition ?? [];

          if(tuitions.length != 0){
            return Scaffold(
              appBar: AppBar(
                backgroundColor: tutorData.isPremium ? purplePlus : orangePlus,
                title: Text("Your Tuition"),
                centerTitle: true,
                elevation: 0.0,
              ),

              body: ListView.builder(
                itemCount: tuitions.length,
                itemBuilder: (context, index) {
                  return TuitionTile(tuition: tuitions[index], tuitionIndex: index, removeTuition: _removeTuition, isPremium: tutorData.isPremium);
                }
              ),
            );

          }else{
             return Scaffold(
              appBar: AppBar(
                backgroundColor: amberPlus,
                title: Text("Your Tuition"),
                centerTitle: true,
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
                        child: Text("You have not created any tuition yet!",
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
        }else{
          return Loading(); 
        }
      }
    );
  }
}

class TuitionTile extends StatelessWidget {

  final Map tuition;
  final int tuitionIndex;
  final bool isPremium;
  final Function removeTuition;
  TuitionTile({ this.tuition, this.tuitionIndex, this.removeTuition, this.isPremium });

  void _alertDialogTuitionInfo({BuildContext context, tuitionName, tuitionDescription, tuitionIsPremium, tuitionIsOnline}) {

    var alert = AlertDialog(
      title: Text(tuitionName,
        style: TextStyle(color: tuitionIsPremium ? purplePlus : orangePlus, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      backgroundColor: whitePlus,
      content: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
          children: [
            TextSpan(text: "Description: \n"),
            TextSpan(text: tuitionDescription,
              style: TextStyle(fontSize: 14)
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon( tuitionIsOnline? Icons.headset_mic : Icons.headset_off,),
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon( Icons.cancel,
            color: Colors.red,),
          ),
          onTap: () {
            Navigator.pop(context);
            _alertDialogConfirmDeletion(context: context);
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

  void _alertDialogConfirmDeletion({BuildContext context}) {

    final tuitionRef = tuition['tuition_ref'];
    final tuitionName = tuition['tuition_name'];

    var alert = AlertDialog(
      backgroundColor: whitePlus,
      content: Text("Are you sure you want to remove your selected tuition?",
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
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ), 
            )
          ),
          onTap: (){
            Navigator.pop(context);
            removeTuition(tuitionRef: tuitionRef, tuitionIndex: tuitionIndex, tuitionName: tuitionName);
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

    final tuitionName = tuition['tuition_name'];
    final tuitionCategory = tuition['tuition_category'];
    final tuitionLevel = tuition['tuition_level'];
    final tuitionDescription = tuition['tuition_description'];
    final tuitionIsOnline = tuition['tuition_isOnline'];

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
          title: Text(tuitionName,
            style: TextStyle(color: isPremium? purplePlus : orangePlus),
          ),
          subtitle: Text('Subject: '+ tuitionCategory +'\nLevel: '+ tuitionLevel),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Icon(Icons.info,),
                onTap: (){
                  _alertDialogTuitionInfo(
                    context: context, 
                    tuitionName: tuitionName, 
                    tuitionDescription: tuitionDescription, 
                    tuitionIsPremium: isPremium,
                    tuitionIsOnline: tuitionIsOnline,
                  );
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