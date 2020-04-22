import 'package:flutter/material.dart';
import 'package:tutorsplus/models/tuition.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/screens/search-view/selected-tutor.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/transition-animations.dart';

class TuitionTile extends StatelessWidget {

  final Tuition tuition;
  final int premiumTuitionsCount;
  final int currentIndex;
  final int selectedTuitionIndex;
  final UserData userData;
  final bool tuitionIsFavourited;
  final Function rebuildSearch;

  TuitionTile({
    this.tuition,
    this.premiumTuitionsCount,
    this.currentIndex,
    this.selectedTuitionIndex,
    this.userData,
    this.tuitionIsFavourited,
    this.rebuildSearch,
  });

 void _alertDialogTuitionActions({BuildContext context}) {

    var alert = AlertDialog(
      title: Text(tuition.name,
        style: TextStyle(color: tuition.isPremium ? purplePlus : orangePlus, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      backgroundColor: whitePlus,
      content: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
          children: [
            TextSpan(text: "Description: \n"),
            TextSpan(text: tuition.description,
              style: TextStyle(fontSize: 14)
            ),
          ],
        ),
      ),
      actions: <Widget>[
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(tuitionIsFavourited? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
          onTap: () async {
            if(tuitionIsFavourited){
              Navigator.pop(context);
              await DatabaseService(uid: userData.uid).removeFavourite(tuition);
              rebuildSearch();
            }else{
              Navigator.pop(context);
              await DatabaseService(uid: userData.uid).addFavourite(tuition);
              rebuildSearch();
            } 
          },
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon( Icons.person ),
          ),
          onTap: (){
            Navigator.pop(context);
            Navigator.push(context, ScaleToRoute(page: SelectedTutorProfile(tutorRef: tuition.tutorRef)));
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

  Widget _tuitionCard(context) {

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10)
        ),
        side: tuition.isPremium
            ? BorderSide(
                color: purplePlus,
                width: currentIndex == selectedTuitionIndex ? 5.0 : 0)
            : BorderSide(
                color: amberPlus,
                width: currentIndex == selectedTuitionIndex ? 5.0 : 0)
        ),
      margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
      elevation: 3,
      color: whitePlus,
      child: ListTile(
        leading: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('assets/book.png'),
        ),
        trailing: IconButton(
          icon: Icon(Icons.info),
          iconSize: 25,
          color: greyPlus,
          onPressed: () => _alertDialogTuitionActions(context: context),
        ),
        title: Text(tuition.name,
            style: !tuition.isPremium
                ? TextStyle(color: amberPlus)
                : TextStyle(color: purplePlus)),
        subtitle: Text(
          'Subject: ${tuition.category}\nLevel: ${tuition.level}',
          style: TextStyle(color: greyPlus),
        ),
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
    return Column(
      children: <Widget>[
        currentIndex == 0 && premiumTuitionsCount != 0
            ? _premiumDivider(context)
            : Container(),
        currentIndex == premiumTuitionsCount
            ? _freemiumDivider(context)
            : Container(),
        _tuitionCard(context),
      ],
    );
  }
}


