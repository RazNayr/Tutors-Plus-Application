import 'package:flutter/material.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/loading.dart';

class UserFavourites extends StatefulWidget {

  final UserData userData;

  UserFavourites({this.userData});

  @override
  _UserFavouritesState createState() => _UserFavouritesState();
}

class _UserFavouritesState extends State<UserFavourites> {

  List _favouritesToRemove = new List();
  bool _loading = false;

  void toggleFavourite(tuitionRef){
    //Set State to rebuild the widget tree
    setState(() {
      if(_favouritesToRemove.contains(tuitionRef)){
        _favouritesToRemove.remove(tuitionRef);
      }else{
        _favouritesToRemove.add(tuitionRef);
      }
    });
  }

  Widget _buildRemoveButton(uid){
    if(_favouritesToRemove.length > 0){
      return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 75),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: greyPlus,
          child: Text(
            'Update Favourites',
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
              _loading = true;
            });
            await DatabaseService(uid: uid).removeUserFavourites(_favouritesToRemove);
            setState(() {
              _favouritesToRemove.clear();
              _loading = false;
            });
          }
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {

    final UserData userData = widget.userData;
    final favourites = userData.favourites ?? [];

    if(favourites.length != 0){

      return _loading ? Loading() : Scaffold(
        appBar: AppBar(
          backgroundColor: amberPlus,
          title: Text("Your Favourites"),
          elevation: 0.0,
        ),

        body: Container(
          child: Column(
            children: <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: favourites.length,
                itemBuilder: (context, index) {
                  return FavouriteTile(favourite: favourites[index], toggleFavourite: toggleFavourite, favouritesToRemove: _favouritesToRemove);
                }
              ),
              _buildRemoveButton(userData.uid),
            ],
          ),
        ),
      );

    }else{

      return _loading ? Loading() : Scaffold(
        appBar: AppBar(
          backgroundColor: amberPlus,
          title: Text("Your Favourites"),
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
                  child: Text("You have not liked any tuition yet!",
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

    
  }
}

class FavouriteTile extends StatelessWidget {

  final Map favourite;
  final Function toggleFavourite;
  final List favouritesToRemove;

  FavouriteTile({ this.favourite, this.toggleFavourite, this.favouritesToRemove });

  void _alertDialogTuitionInfo(BuildContext context, tuitionName, tuitionTutor, tuitionDescription, tuitionIsPremium, tuitionIsOnline) {

    var alert = AlertDialog(
      title: Text(tuitionName,
        style: TextStyle(color: greyPlus, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      backgroundColor: whitePlus,
      content: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
          children: [
            TextSpan(text: "Tutor: "),
            TextSpan(text: tuitionTutor, 
              style: tuitionIsPremium ? TextStyle(color: purplePlus) : TextStyle(color: orangePlus) ),
            TextSpan(text: "\n"),
            TextSpan(text: tuitionDescription,
              style: TextStyle(fontSize: 14)
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Icon( tuitionIsOnline? Icons.headset_mic : Icons.headset_off),
        IconButton(
          icon: Icon(Icons.person_pin), 
          onPressed: () => Navigator.pop(context)
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

  @override
  Widget build(BuildContext context) {
    final tuitionName = favourite['tuition_name'];
    final tuitionCategory = favourite['tuition_category'];
    final tuitionLevel = favourite['tuition_level'];
    final tuitionTutor = favourite['tuition_tutor'];
    final tuitionDescription = favourite['tuition_description'];
    final tuitionRef = favourite['tuition_ref'];
    final tuitionIsPremium = favourite['tuition_isPremium'];
    final tuitionIsOnline = favourite['tuition_isOnline'];

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
          title: Text(tuitionName),
          subtitle: Text('Subject: '+ tuitionCategory +'\nLevel: '+ tuitionLevel),
          trailing: Column(
            children: <Widget>[
              GestureDetector(
                child: Icon(
                  !favouritesToRemove.contains(tuitionRef.path) ? Icons.favorite : Icons.favorite_border, 
                  color: Colors.red,
                ),
                onTap: (){
                  toggleFavourite(tuitionRef.path);
                },
              ),
              GestureDetector(
                child: Icon(Icons.info,),
                onTap: (){
                  _alertDialogTuitionInfo(context, tuitionName, tuitionTutor, tuitionDescription, tuitionIsPremium, tuitionIsOnline);
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