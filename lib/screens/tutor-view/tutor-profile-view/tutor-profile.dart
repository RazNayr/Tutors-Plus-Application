import 'package:flutter/material.dart';
import 'package:tutorsplus/shared/common.dart';

class TutorProfile extends StatefulWidget {
  @override
  _TutorProfileState createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/profile-icon.jpg')
              ),
            ),
          ),

          ListTile(
            contentPadding: EdgeInsets.all(0),
            dense: true,
            title: Text(
              "Edit Profile",
              style: TextStyle(color: greyPlus, fontSize: 20)),
            leading: Icon(Icons.person_outline),
            onTap: () {
              
            }
          ),

          ListTile(
            contentPadding: EdgeInsets.all(0),
            dense: true,
            title: Text(
              "View Special Offers",
              style: TextStyle(color: greyPlus, fontSize: 20)),
            leading: Icon(Icons.insert_emoticon),
          ),

          ListTile(
            contentPadding: EdgeInsets.all(0),
            dense: true,
            title: Text(
              "View Lessons",
              style: TextStyle(color: greyPlus, fontSize: 20)),
            leading: Icon(Icons.format_list_bulleted),
            onTap: () {
              
            }
          ),

          ListTile(
            contentPadding: EdgeInsets.all(0),
            dense: true,
            title: Text(
              "View Favourites",
              style: TextStyle(color: greyPlus, fontSize: 20)),
            leading: Icon(Icons.favorite_border),
            onTap: () {
              
            }
          ),

        ],
      ),
    );
  }
}