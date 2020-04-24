import 'package:flutter/material.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorsplus/models/tuition.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tutorsplus/screens/home-view/tuition_tile.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/loading.dart';
import '../../shared/common.dart';

class Home extends StatefulWidget {
  final UserData userData;
  Home({this.userData});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double height = 0;
  double width = 0;

  int _current = 0;
  bool tuitionsToggle = false;
  List<Tuition> tuitions = List<Tuition>();

  // void _timeDayCheck() {
  //   var hour = DateTime.now().hour;
  //   setState(() {
  //     if (hour < 12) {
  //       _timeDay = 1;
  //     } else if (hour < 17) {
  //       _timeDay = 2;
  //     } else {
  //       _timeDay = 3;
  //     }
  //   });
  // }

  void populateTuitions() {
    Firestore.instance.collection('tuition').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          tuitionsToggle = true;
        });
        for (int i = 0; i < docs.documents.length; ++i) {
          String tuitionId = LatLng(
                  docs.documents[i].data['tuition_geopoint'].latitude,
                  docs.documents[i].data['tuition_geopoint'].longitude)
              .toString();
          Tuition newTuition = new Tuition(
            // tuitionId,
            // docs.documents[i].data['tuition_title'],
            // docs.documents[i].data['tutor_name'],
            // docs.documents[i].data['tuition_category'],
            // docs.documents[i].data['tuition_level'],
            // docs.documents[i].data['isPremium'],
            // docs.documents[i].data['locality'],
            // docs.documents[i].data['tuition_geopoint'].longitude,
            // docs.documents[i].data['tuition_geopoint'].latitude);
            id: tuitionId,
            isPremium: docs.documents[i].data['tuition_isPremium'],
            isOnline: docs.documents[i].data['tuition_isOnline'],
            category: docs.documents[i].data['tuition_category'],
            level: docs.documents[i].data['tuition_level'],
            name: docs.documents[i].data['tuition_name'],
            tutor: docs.documents[i].data['tuition_tutor'],
            description: docs.documents[i].data['description'],
            locality: docs.documents[i].data['tuition_locality'],
            tutorRef: docs.documents[i].data['tuition_tutorRef'],
            latitude: docs.documents[i].data['tuition_geopoint'].latitude,
            longitude: docs.documents[i].data['tuition_geopoint'].longitude,
          );
          tuitions.add(newTuition);
        }
      }
    });
  }

  void initState() {
    super.initState();
    // _timeDayCheck();
    populateTuitions();
  }

  Widget _carouselSlider(BuildContext context) {
    final List<String> imgList = [
      'https://hillelontario.org/uoft/files/2019/08/WelcomeBanners-UofT-1-1080x675.png',
      'https://www.schoolfeesgroup.ae/wp-content/uploads/2018/12/AdobeStock_88074933.jpg',
      'https://d19d5sz0wkl0lu.cloudfront.net/dims4/default/b2928d2/2147483647/resize/800x%3E/quality/90/?url=https%3A%2F%2Fatd-brightspot.s3.amazonaws.com%2F7f%2F38%2Fb37d0d6148e48fea8f76209eb3bb%2Fbigstock-pretty-teacher-smiling-at-came-69887626-1.jpg',
      'https://cdn.mos.cms.futurecdn.net/gmbHWBEMwL3nZYJ9jRYPC.jpg',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://previews.123rf.com/images/goodstudio/goodstudio1807/goodstudio180700503/105507176-horizontal-banner-with-stationery-supplies-and-accessories-for-lessons-items-for-education-back-to-s.jpg'
    ];

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              'Image ${imgList.indexOf(item)+1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();

    return Column(children: <Widget>[
      CarouselSlider(
        items: imageSliders,
        options: CarouselOptions(
            height: height * 0.3,
            aspectRatio: 16 / 9,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            initialPage: 0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Container(
        height: height * 0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.map((url) {
            int index = imgList.indexOf(url);
            return Container(
              width: 10,
              height: 10,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index ? orangePlus : greyPlus,
              ),
            );
          }).toList(),
        ),
      )
    ]);
  }

  Widget _loadNewTuition(UserData userData, List<Tuition> tuitionList) {
    List<String> userInterests = userData.interests ?? new List();
    List<String> userSearchHistory = userData.searchHistory ?? new List();
    List<Tuition> customTuitionToShow = new List();

    tuitionList.forEach((tuition){
      if(userInterests.contains(tuition.category) || userSearchHistory.contains(tuition.category)){
        customTuitionToShow.add(tuition);
      }
    });

    if(customTuitionToShow.length > 0){
      return ListView.builder(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        itemCount: customTuitionToShow.length,
        itemBuilder: (context, index) {
          Tuition tuition = customTuitionToShow[index];
          return TuitionTile(tuition: tuition, index: index);
        }
      );
    }else{
      return ListView.builder(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        itemCount: tuitionList.length<5 ? tuitionList.length : 5,
        itemBuilder: (context, index) {
          Tuition tuition = tuitionList[index];
          return TuitionTile(tuition: tuition, index: index);
        }
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return StreamBuilder<List<Tuition>>(
        stream: DatabaseService().tuitionList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Tuition> tuitionList = snapshot.data;

            return Container(
              height: double.infinity,
              width: double.infinity,
              color: blackPlus,
              child: Column(
                children: <Widget>[
                  // SizedBox(height: 30),

                  // Container(
                  //     width: width* 0.9,
                  //     height: height * 0.1,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(30.0),
                  //       color: whitePlus,
                  //       border: Border.all(
                  //         color: greyPlus,
                  //         width: 1.5,
                  //       ),
                  //     ),
                  //     child: Center(
                  //         child: _timeDay == 1
                  //             ? Text(
                  //                 'Good Morning! 🌞',
                  //                 style: TextStyle(
                  //                   color: blackPlus,
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: 38,
                  //                 ),
                  //               )
                  //             : _timeDay == 2
                  //                 ? Text(
                  //                     'Good Afternoon! ☀️',
                  //                     style: TextStyle(
                  //                       color: blackPlus,
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 38,
                  //                     ),
                  //                   )
                  //                 : Text(
                  //                     'Good Evening! 🌙',
                  //                     style: TextStyle(
                  //                       color: blackPlus,
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 38,
                  //                     ),
                  //                   ))),

                  SizedBox(height: 20),

                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: height * 0.5,
                        minHeight: 0,
                        maxWidth: width * 0.9,
                        minWidth: width * 0.9),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: whitePlus,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                            child: Text(
                              'New offers coming your way...',
                              style: TextStyle(
                                  color: greyPlus,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: _carouselSlider(context),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                    width: width * 0.9,
                    height: height * 0.38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: whitePlus,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Text(
                            'Check out new tuition that you might like!',
                            style: TextStyle(
                                color: greyPlus,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: width * 0.9,
                          height: height * 0.3,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: tuitionsToggle
                              ? _loadNewTuition(widget.userData, tuitionList)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
