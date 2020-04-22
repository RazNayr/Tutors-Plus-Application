import 'package:flutter/material.dart';
import 'package:tutorsplus/models/tuition.dart';
import 'package:tutorsplus/shared/common.dart';

class TuitionTile extends StatelessWidget {
  TuitionTile({this.tuition,this.index});
  final Tuition tuition;
  final int index;
  
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