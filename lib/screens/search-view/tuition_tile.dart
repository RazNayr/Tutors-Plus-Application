import 'package:flutter/material.dart';
import 'package:tutorsplus/models/tuition.dart';
import 'package:tutorsplus/shared/common.dart';

class TuitionTile extends StatelessWidget {
  TuitionTile(
      {this.tuition,
      this.premiumTuitionsCount,
      this.currentIndex,
      this.selectedTuitionIndex});
  final Tuition tuition;
  final int premiumTuitionsCount;
  final int currentIndex;
  final int selectedTuitionIndex;

  void _addToFavouriteTuitions() {
    print('TODO');

    // add the tuition object to the list of favourited tuitions for this
    // user in firebase
  }

  void _zoomOnMarker() {
    print('TODO');

    // somehow this method must pass the tuition object to the main widget
    // which is FUCKING impossible
  }

  Widget _tuitionCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topRight: Radius.circular(10)),
          side: tuition.isPremium
              ? BorderSide(
                  color: purplePlus,
                  width: currentIndex == selectedTuitionIndex ? 5.0 : 0)
              : BorderSide(
                  color: amberPlus,
                  width: currentIndex == selectedTuitionIndex ? 5.0 : 0)),
      margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
      elevation: 3,
      // color: tuition.premium ? purplePlus : orangePlus,
      color: whitePlus,
      child: ListTile(
        leading: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.white,
          child: Text('T+'),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.pin_drop),
              iconSize: 18,
              color: greyPlus,
              onPressed: _zoomOnMarker,
            ),
            IconButton(
              icon: Icon(Icons.favorite_border),
              iconSize: 18,
              color: greyPlus,
              onPressed: _addToFavouriteTuitions,
            ),
          ],
        ),
        title: Text(tuition.name,
            style: !tuition.isPremium
                ? TextStyle(color: amberPlus)
                : TextStyle(color: purplePlus)),
        subtitle: Text(
          '${tuition.tutor}\n${tuition.category} • ${tuition.level}',
          style: TextStyle(color: greyPlus),
        ),
        //subtitle: Text('Tutor: ${tuition.tutorName}\nMathematics • MATSEC A Level'),
        isThreeLine: true,
      ),
    );
  }

  Widget _premiumDivider(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: 45,
            width: MediaQuery.of(context).size.width / 1.15,
            decoration: new BoxDecoration(
                color: purplePlus,
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: whitePlus,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                )),
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.star, size: 30.0, color: whitePlus),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  alignment: Alignment.center,
                  child: Text(
                    'PREMIUM',
                    style: TextStyle(color: whitePlus, fontSize: 20),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.star, size: 30.0, color: whitePlus),
                ),
              ],
            )),
        Divider(
          color: whitePlus.withOpacity(0),
          height: 10,
        ),
      ],
    );
  }

  Widget _freemiumDivider(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(
          color: whitePlus.withOpacity(0),
          height: 10,
        ),
        Container(
          height: 45,
          width: MediaQuery.of(context).size.width / 1.15,
          decoration: new BoxDecoration(
              color: amberPlus,
              shape: BoxShape.rectangle,
              border: Border.all(
                color: whitePlus,
                width: 1.5,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'FREEMIUM',
              style: TextStyle(color: whitePlus, fontSize: 20),
            ),
          ),
        ),
        Divider(
          color: whitePlus.withOpacity(0),
          height: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Column(
          children: <Widget>[
            currentIndex == 0 && premiumTuitionsCount != 0
                ? _premiumDivider(context)
                : Container(),
            currentIndex == premiumTuitionsCount
                ? _freemiumDivider(context)
                : Container(),
            _tuitionCard(context),
          ],
        ));
  }
}
