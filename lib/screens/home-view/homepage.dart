import 'package:flutter/material.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorsplus/models/tuition.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tutorsplus/screens/home-view/tuition_tile.dart';
import '../../shared/common.dart';
import '../../shared/common.dart';

class Home extends StatefulWidget {
  final UserData userData;

  Home({this.userData});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _timeDay = 0;
  bool tuitionsToggle = false;
  List <Tuition> tuitions = List<Tuition>();

  void _timeDayCheck() {
    var hour = DateTime.now().hour;
    setState(() {
      if (hour < 12) {
        _timeDay = 1;
      }
      if (hour < 17) {
        _timeDay = 2;
      }
      _timeDay = 3;
    });
    print(hour);
  }

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
    _timeDayCheck();
    populateTuitions();
  }

  Widget _carouselSlider(BuildContext context) {
    int _current = 0;
    final List<String> imgList = [
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
    ];

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
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
                              'New offers on laptops at this store! (Sponsored)',
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
            height: 140,
            aspectRatio: 16 / 9,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Container(
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.map((url) {
            int index;
            setState(() => index = imgList.indexOf(url));
            //print(index);
            return Container(
              width: 16.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
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

  Widget _loadNewTuition(BuildContext context) {
    var listView =  ListView.builder(
        itemCount: tuitions.length,
        itemBuilder: (BuildContext context, int index) {
          return TuitionTile(
              tuition: tuitions[index], index: index,);
        });
    return listView;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackPlus,
      child: Column(
        children: <Widget>[
          SizedBox(height: 45),
          Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.height / 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: whitePlus,  
                border: Border.all(
                  color: greyPlus,
                  width: 1.5,
                ),              
              ),
              child: Center(
                  child: _timeDay == 1
                      ? Text(
                          'Good Morning! 🌞',
                          style: TextStyle(
                            color: blackPlus,
                            fontWeight: FontWeight.bold,
                            fontSize: 38,
                          ),
                        )
                      : _timeDay == 2
                          ? Text(
                              'Good Afternoon! ☀️',
                              style: TextStyle(
                                color: blackPlus,
                                fontWeight: FontWeight.bold,
                                fontSize: 38,
                              ),
                            )
                          : Text(
                              'Good Evening! 🌙',
                              style: TextStyle(
                                color: blackPlus,
                                fontWeight: FontWeight.bold,
                                fontSize: 38,
                              ),
                            ))),
          SizedBox(height: 30),
          Container(
            width: MediaQuery.of(context).size.width / 1.1,
            //height: MediaQuery.of(context).size.height / 3.21,
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: whitePlus,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 60, 0),
                  child: Text(
                    'New offers coming your way...',
                    style: TextStyle(
                      color: greyPlus,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: _carouselSlider(context),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            width: MediaQuery.of(context).size.width / 1.1,
            //height: MediaQuery.of(context).size.height / 3.21,
            height: MediaQuery.of(context).size.height / 3.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: whitePlus,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 1, 0),
                  child: Text(
                    'Check out new tuition that you might like!',
                    style: TextStyle(
                      color: greyPlus,
                      fontSize: 19,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: MediaQuery.of(context).size.height / 3.9,
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: tuitionsToggle ? _loadNewTuition(context) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
