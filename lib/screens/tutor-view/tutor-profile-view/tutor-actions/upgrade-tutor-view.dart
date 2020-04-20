import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutorsplus/models/tutor.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:confetti/confetti.dart';


class UpgradeTutor extends StatefulWidget {

  final TutorData tutorData;

  UpgradeTutor({this.tutorData});

  @override
  _UpgradeTutorState createState() => _UpgradeTutorState();
}

class _UpgradeTutorState extends State<UpgradeTutor> {

  //final loadingColours = [orangePlus, amberPlus];
  final _loadingColoursPremium = [purplePlus, Colors.deepPurple[200]];
  bool _welcomePremiumTutor = false;
  

  @override
  Widget build(BuildContext context) {

    final TutorData tutorData = widget.tutorData;

    return _welcomePremiumTutor? WelcomePremiumTutor() : Material(
      child: Container(
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
                    color: _loadingColoursPremium[index%2]
                  ),
                );
              },
            ),

            SizedBox(height: 60,),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text("Are you ready to become a premium Tutor?",
              textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: greyPlus,
                  fontWeight: FontWeight.bold,
                ),
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
                  'Pay €12.99 a month',
                  style: TextStyle(
                    color: whitePlus,
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _welcomePremiumTutor = true;
                  });

                  await new Future.delayed(const Duration(seconds : 8));
                  await DatabaseService(uid: tutorData.uid).upgradeToPremium();
                  Navigator.pop(context);
                }
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 150),
              width: double.infinity,
              child: RaisedButton(
                elevation: 5.0,
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: greyPlus,
                child: Text(
                  'Not yet',
                  style: TextStyle(
                    color: whitePlus,
                    letterSpacing: 1.5,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }
              ),
            ),

            
          ],
        ),
      ),
    );
  }
}

class WelcomePremiumTutor extends StatefulWidget {
  @override
  _WelcomePremiumTutorState createState() => _WelcomePremiumTutorState();
}

class _WelcomePremiumTutorState extends State<WelcomePremiumTutor> {

  final _loadingColoursPremium = [purplePlus, Colors.deepPurple[200]];

  ConfettiController _controllerBottomRight;
  ConfettiController _controllerBottomLeft;

  @override
  void initState() {
    _controllerBottomRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerBottomLeft =
        ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
  }

  @override
  void dispose() {
    _controllerBottomRight.dispose();
    _controllerBottomLeft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _controllerBottomRight.play();
    _controllerBottomLeft.play();

    return Stack(children: <Widget>[

      Material(
        child: Container(
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
                      color: _loadingColoursPremium[index%2]
                    ),
                  );
                },
              ),

              SizedBox(height: 60,),

              Text("Congratulations!",
                style: TextStyle(
                  fontSize: 30,
                  color: greyPlus,
                  fontWeight: FontWeight.bold
                ),
              ),

              SizedBox(height: 30,),

              Text("You are now a Premium Tutor",
                style: TextStyle(
                  fontSize: 25,
                  color: greyPlus
                ),
              ),
            ],
          ),
        ),
      ),

      //BOTTOM RIGHT CONFETTI
      Align(
        alignment: Alignment.bottomRight,
        child: ConfettiWidget(
          confettiController: _controllerBottomRight,
          maxBlastForce: 100,
          minBlastForce: 40,
          blastDirection: pi+(pi/4)+(pi/6),
          particleDrag: 0.05,
          emissionFrequency: 0.01,
          numberOfParticles: 10,
          gravity: 0.05,
          shouldLoop: true,
          colors: [
            Colors.purple[50],
            pinkPlus,
            purplePlus
          ],
        ),
      ),

      //BOTTOM Left CONFETTI
      Align(
        alignment: Alignment.bottomLeft,
        child: ConfettiWidget(
          confettiController: _controllerBottomLeft,
          maxBlastForce: 100,
          minBlastForce: 40,
          blastDirection: 0-(pi/4)-(pi/6),
          particleDrag: 0.05,
          emissionFrequency: 0.01,
          numberOfParticles: 10,
          gravity: 0.05,
          shouldLoop: true,
          colors: [
            Colors.purple[50],
            pinkPlus,
            purplePlus
          ],
        ),
      ),
    ],);
    
  }
}

