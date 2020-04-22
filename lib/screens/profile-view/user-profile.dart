import 'package:flutter/material.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/services/auth.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/transition-animations.dart';

import 'user-actions/edit-profile-view.dart';
import 'user-actions/favourites-view.dart';
import 'user-actions/lessons-view.dart';

class UserProfile extends StatefulWidget {

  final UserData userData;

  UserProfile({this.userData});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final UserData userData = widget.userData;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
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
              Navigator.push(context, SlideToRoute(page: EditUserProfile(userData: userData),type: "left"));
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
              Navigator.push(context, SlideToRoute(page: UserLessons(userData: userData),type: "left"));
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
              Navigator.push(context, SlideToRoute(page: UserFavourites(userData: userData),type: "left"));
            }
          ),

          ListTile(
            contentPadding: EdgeInsets.all(0),
            dense: true,
            title: Text(
              "Contact Us",
              style: TextStyle(color: greyPlus, fontSize: 20)),
            leading: Icon(Icons.help_outline),
          ),

          ListTile(
            contentPadding: EdgeInsets.all(0),
            dense: true,
            title: Text(
              "Log out",
              style: TextStyle(color: greyPlus, fontSize: 20)),
            leading: Icon(Icons.exit_to_app),
            onTap: () async => await _auth.signOut(),
          ),

        ],
      ),
    );
  }
}