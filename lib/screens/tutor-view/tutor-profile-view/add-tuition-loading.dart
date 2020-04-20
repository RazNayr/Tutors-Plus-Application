import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutorsplus/shared/common.dart';

class AddingTuition extends StatelessWidget {

  final bool isPremium;

  AddingTuition({this.isPremium});

  final loadingColours = [orangePlus, amberPlus];
  final loadingColoursPremium = [purplePlus, Colors.deepPurple[200]];

  @override
  Widget build(BuildContext context) {
    return Material(
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
                    color: isPremium? loadingColoursPremium[index%2] : loadingColours[index%2]
                  ),
                );
              },
            ),

            SizedBox(height: 60),

            Text("Adding Tuition",
              style: TextStyle(
                fontSize: 30,
                color: greyPlus,
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
