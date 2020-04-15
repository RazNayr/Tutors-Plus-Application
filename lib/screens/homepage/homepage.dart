import 'package:flutter/material.dart';
import 'package:tutorsplus/screens/user-actions/view-favourites.dart';
import 'package:tutorsplus/screens/user-actions/view-lessons.dart';
import 'package:tutorsplus/services/auth.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/screens/user-actions/edit-profile.dart';

class Homepage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      // appBar: AppBar(
      //   backgroundColor: blackPlus,
      //   elevation: 0.0,
      //   title: Text('HomePage'),
      //   actions: <Widget>[
      //     FlatButton.icon(
      //       icon: Icon(Icons.person),
      //       label: Text('Sign Out'),
      //       onPressed: () async => await _auth.signOut(),
      //     ),
      //   ],
      // ),

      body: HomeDashboard()
    );
  }
}


class HomeDashboard extends StatefulWidget {
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> with SingleTickerProviderStateMixin{

  bool _isCollapsed = true;
  double screenWidth;
  double screenHeight;
  final Duration _duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0.6, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0,0)).animate(_controller);
  }
  
  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: whitePlus,
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context)
        ],
      ),
    );
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 30, bottom: 20),
                  padding: EdgeInsets.all(0),
                  width: 160,
                  height: 160,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
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
                  leading: Icon(Icons.person),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditUserProfile()));
                  }
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Text(
                    "Become a Tutor",
                    style: TextStyle(color: greyPlus, fontSize: 20)),
                  leading: Icon(Icons.school),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Text(
                    "View Lessons",
                    style: TextStyle(color: greyPlus, fontSize: 20)),
                  leading: Icon(Icons.view_list),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserLessons()));
                  }
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Text(
                    "View Favourites",
                    style: TextStyle(color: greyPlus, fontSize: 20)),
                  leading: Icon(Icons.favorite),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserFavourites()));
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
          ),
        ),
      ),
    );
  }

  Widget dashboard(context){
    return AnimatedPositioned(
      duration: _duration,
      top: 0,
      bottom: 0,
      left: _isCollapsed ? 0 : 0.55 * screenWidth,
      right: _isCollapsed ? 0 : -0.55 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          elevation: 8,
          color: whitePlus,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.only(left: 16, top: 48, right:16),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        child: Icon(Icons.menu, color: greyPlus),
                        onTap: () => setState(() {
                          _isCollapsed ? _controller.forward() : _controller.reverse();
                          _isCollapsed = !_isCollapsed;
                        })
                      ),
                      Text("Search for Tuition here",style: TextStyle(fontSize: 24, color: greyPlus)),
                      Icon(Icons.search, color: greyPlus,)
                  ]),
                  // PageView.builder(itemBuilder: (context, index){
                  //   return tile;
                  // }),
                  SizedBox(height:50),

                  Container(
                    height: 200,
                    child: PageView(
                      controller: PageController(viewportFraction: 0.8),
                      scrollDirection: Axis.horizontal,
                      pageSnapping: true,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: yellowPlus,
                          width: 100,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: amberPlus,
                          width: 100,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: orangePlus,
                          width: 100,
                        ),
                    ],)
                  ),

                  SizedBox(height:30),
                  Text("New Tutors", style: TextStyle(color: greyPlus, fontSize: 20),),

                  Container(
                    height: screenHeight * 0.4,
                    padding: null,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return ListTile(
                          title: Text("Tutor", style: TextStyle(color: greyPlus)),
                          subtitle: Text("Category: Maths", style: TextStyle(color: greyPlus)),
                          trailing: Icon(Icons.accessibility_new, color: blackPlus),
                        );
                      },
                      separatorBuilder: (context, index){
                        return Divider(height: 10, color: Colors.white);
                      },
                      itemCount: 10
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
