import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/bottom-app-bar.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/loading.dart';

import 'home-view/homepage.dart';
import 'messenger-view/messenger.dart';
import 'profile-view/user-profile.dart';
import 'tutor-view/tutor-wrapper.dart';

class PageWrapper extends StatefulWidget {
  PageWrapper({Key key}) : super(key: key);

  @override
  _PageWrapperState createState() => new _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> with TickerProviderStateMixin {
  int bottomSelectedIndex = 1;

  //When tapping the Floating Action Button
  // void _selectedFab(int index) {
  //   setState(() {
  //     //bottomSelectedIndex = index;
  //   });
  // }

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  Widget buildPageView(userData) {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        UserProfile(userData: userData),
        Home(userData: userData),
        Messenger(userData: userData),
        TutorWrapper(userData: userData),
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void _bottomTapped(int index) {
    setState(() {
      if (bottomSelectedIndex+1 == index || bottomSelectedIndex-1 == index){
        bottomSelectedIndex = index;
        pageController.animateToPage(
          index, 
          duration: Duration(milliseconds: 500), 
          curve: Curves.easeInOut
        );
      }else{
        pageController.jumpToPage(index);
      }
    
    });
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: whitePlus,

      body: StreamBuilder<Object>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            UserData userData = snapshot.data;
            return buildPageView(userData);
          }else{
            return Loading();
          }
        }
      ),

      bottomNavigationBar: FABBottomAppBar(
        currentIndex: bottomSelectedIndex,
        shadowColor: Colors.black12,
        color: Colors.grey,
        blurRadius: 10.0,
        backgroundColor: Colors.white,
        selectedColor: orangePlus,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _bottomTapped,
        items: [
          FABBottomAppBarItem(iconData: Icons.menu, text: 'Profile'),
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.chat, text: 'Chat'),
          FABBottomAppBarItem(iconData: Icons.school, text: 'Tutor'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        tooltip: 'Search Tuition',
        elevation: 2.0,
        backgroundColor: amberPlus,
        onPressed: () {},
      ),
    );
  }

}
