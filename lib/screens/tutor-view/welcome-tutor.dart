import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutorsplus/shared/common.dart';

class WelcomeTutor extends StatelessWidget {

  final Function toggleWelcomeView;

  WelcomeTutor({this.toggleWelcomeView});

  //final loadingColours = [orangePlus, amberPlus];
  final loadingColoursPremium = [purplePlus, Colors.deepPurple[200]];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whitePlus,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitFadingCube(
            size: 100,
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: loadingColoursPremium[index%2]
                ),
              );
            },
          ),

          SizedBox(height: 60,),

          Text("You are now a Tutor!",
            style: TextStyle(
              fontSize: 30,
              color: greyPlus
            ),
          ),
          
          Container(
            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 75),
            width: double.infinity,
            child: RaisedButton(
              elevation: 5.0,
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: purplePlus,
              child: Text(
                'Continue',
                style: TextStyle(
                  color: whitePlus,
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
              onPressed: ()  {
                toggleWelcomeView();
              }
            ),
          ),
        ],
      ),
    );
  }
}
