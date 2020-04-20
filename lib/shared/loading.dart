import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutorsplus/shared/common.dart';

class Loading extends StatelessWidget {

  final loadingColours = [orangePlus, amberPlus];
  final loadingColoursPremium = [purplePlus, Colors.deepPurple[200]];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whitePlus,
      child: Center(
        child: SpinKitWave(
          size: 100,
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: loadingColours[index%2]
              ),
            );
          },
        ),
      ),
    );
  }
}

class PremiumLoading extends StatelessWidget {

  final loadingColoursPremium = [purplePlus, Colors.deepPurple[200]];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whitePlus,
      child: Center(
        child: SpinKitWave(
          size: 100,
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: loadingColoursPremium[index%2]
              ),
            );
          },
        ),
      ),
    );
  }
}

class BlankLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: whitePlus,
    );
  }
}