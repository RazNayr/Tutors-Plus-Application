import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/loading.dart';

class UserFavourites extends StatefulWidget {
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

    final user = Provider.of<User>(context);

    return _loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: amberPlus,
        title: Text("Your Favourites"),
        elevation: 0.0,
      ),

      body: StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            final favourites = snapshot.data.favourites ?? [];

            if(favourites.length != 0){
              return Container(
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
                    _buildRemoveButton(user.uid),
                  ],
                ),
              );
            }else{
              return Container(
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
              );
            }
          }else{
            return Loading();
          }
        }
      ),
    );
  }
}

// class FavouriteTile extends StatelessWidget {

//   final Map favourite;
//   final Function removeFavourite;
//   final List favouritesToRemove;

//   FavouriteTile({ this.favourite, this.removeFavourite, this.favouritesToRemove });

//   @override
//   Widget build(BuildContext context) {

//     final tuitionTitle = favourite['tuition_title'];
//     final tuitionCategory = favourite['tuition_category'];
//     final tuitionLevel = favourite['tuition_level'];
//     final tuitionTutor = favourite['tuition_tutor'];
//     final tuitionRef = favourite['tuition_ref'];

//     return Padding(
//       padding: const EdgeInsets.only(top: 8.0),
//       child: Card(
//         margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
//         child: ListTile(
//           leading: CircleAvatar(
//             radius: 25.0,
//             backgroundColor: Colors.white,
//             backgroundImage: AssetImage('assets/book.png'),
//           ),
//           title: Text(tuitionTitle),
//           subtitle: Text('Subject: '+ tuitionCategory +'\nLevel: '+ tuitionLevel),
//           trailing: GestureDetector(
//             child: Icon(
//               !favouritesToRemove.contains(favourite) ? Icons.favorite : Icons.favorite_border, 
//               color: Colors.red,
//             ),
//             onTap: (){
//               removeFavourite(favourite);
//             },
//           ),
//           isThreeLine: true
//         ),
//       ),
//     );
//   }
// }

class FavouriteTile extends StatefulWidget {

  final Map favourite;
  final Function toggleFavourite;
  final List favouritesToRemove;

  FavouriteTile({ this.favourite, this.toggleFavourite, this.favouritesToRemove });

  @override
  _FavouriteTileState createState() => _FavouriteTileState();
}

class _FavouriteTileState extends State<FavouriteTile> {

  @override
  Widget build(BuildContext context) {
    final tuitionTitle = widget.favourite['tuition_title'];
    final tuitionCategory = widget.favourite['tuition_category'];
    final tuitionLevel = widget.favourite['tuition_level'];
    final tuitionTutor = widget.favourite['tuition_tutor'];
    final tuitionRef = widget.favourite['tuition_ref'];

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
          title: Text(tuitionTitle),
          subtitle: Text('Subject: '+ tuitionCategory +'\nLevel: '+ tuitionLevel),
          trailing: GestureDetector(
            child: Icon(
              !widget.favouritesToRemove.contains(tuitionRef.path) ? Icons.favorite : Icons.favorite_border, 
              color: Colors.red,
            ),
            onTap: (){
              setState(() {
                widget.toggleFavourite(tuitionRef.path);
              });
            },
          ),
          isThreeLine: true
        ),
      ),
    );
  }
}