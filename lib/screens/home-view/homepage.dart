import 'package:flutter/material.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tutorsplus/models/tuition.dart';
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
  int _timeDay = 0;
  bool tuitionsToggle = false;
  List <Tuition> tuitions = List<Tuition>();

  void _timeDayCheck() {
    var hour = DateTime.now().hour;
    setState(() {
      if (hour < 12) {
        _timeDay = 1;
      } else if (hour < 17) {
        _timeDay = 2;
      }else{
        _timeDay = 3;
      }
    });
  }

  void initState() {
    super.initState();
    _timeDayCheck();
  }

  Widget _carouselSlider(BuildContext context) {
    
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
                margin: EdgeInsets.symmetric(horizontal:2.0, vertical: 2.0),
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

    return Column(
    children: <Widget>[
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
        height: height*0.06,
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

    List<String> userInterests = userData.interests;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0,0,0,10),
      itemCount: tuitionList.length,
      itemBuilder: (context, index){

        Tuition tuition = tuitionList[index];
        if(userInterests.contains(tuition.category)){
          return TuitionTile(tuition: tuition, index: index,);
        }else{
          return SizedBox();
        }

    });
  }

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return StreamBuilder<List<Tuition>>(
      stream: DatabaseService().tuitionList,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          
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
                    maxHeight: height*0.5, 
                    minHeight: 0, 
                    maxWidth: width*0.9,
                    minWidth: width*0.9
                  ),
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
                              fontWeight: FontWeight.bold
                            ),
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
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        width: width * 0.9,
                        height: height*0.3,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: tuitionsToggle ? _loadNewTuition(widget.userData, tuitionList) : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }else{
          return Loading();
        }
        
      }
    );
  }
}
