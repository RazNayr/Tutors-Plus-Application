import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tutorsplus/models/tutor.dart';
import 'package:tutorsplus/shared/common.dart';


class PublicTutorProfile extends StatefulWidget {

  final TutorData tutorData;
  PublicTutorProfile({this.tutorData});

  @override
  _PublicTutorProfileState createState() => _PublicTutorProfileState();
}

class _PublicTutorProfileState extends State<PublicTutorProfile> {

  double screenWidth;
  double screenHeight;

  @override
  Widget build(BuildContext context) {

    TutorData tutorData = widget.tutorData;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: whitePlus,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: screenHeight*0.4,
                width: screenWidth,
                color: tutorData.isPremium? purplePlus : orangePlus,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child:Container(
                        margin: EdgeInsets.fromLTRB(0,30,0,0),
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: whitePlus,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/tutor.png')
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child:Container(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        width: double.infinity,
                        child: Text(tutorData.fname+" "+tutorData.lname,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: whitePlus,
                            fontSize: 20
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            _buildIconIfOnline(tutorData.isOnline),
                            _buildIconIfWarranted(tutorData.isWarranted),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: SmoothStarRating(
                          allowHalfRating: false,
                          starCount: 5,
                          rating: tutorData.rating.toDouble(),
                          size: 30.0,
                          color: whitePlus,
                          borderColor: whitePlus,
                          spacing:0.0
                        ),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 20,),

              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: screenHeight*0.3, 
                  minHeight: 0, 
                  maxWidth: screenWidth*0.8,
                  minWidth: screenWidth*0.8
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text("Tutor Bio",
                        style: TextStyle(
                          color: blackPlus,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    _buildBioWidget(tutorData),
                  ]
                ),
              ),

              SizedBox(height: 30,),

              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: screenHeight, 
                  minHeight: 0, 
                  maxWidth: screenWidth*0.8,
                  minWidth: screenWidth*0.8
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text("Tutor Tuition",
                        style: TextStyle(
                          color: blackPlus,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    _buildTuitionWidget(tutorData),
                  ],
                ),
              ),

              SizedBox(height: 30,),

              Container(
                height: screenHeight*0.3,
                width: screenWidth*0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text("Tuition Map",
                        style: TextStyle(
                          color: blackPlus,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Container(
                          width: double.infinity,
                        ),
                      ),
                    )
                  ]
                ),
              ),

              SizedBox(height: 30,),

              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: screenHeight*0.4, 
                  minHeight: 0, 
                  maxWidth: screenWidth*0.8,
                  minWidth: screenWidth*0.8
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text("Tutor Reviews",
                        style: TextStyle(
                          color: blackPlus,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    _buildReviewsWidget(tutorData),
                  ]
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconIfOnline(isOnline){

    if(isOnline){
      return Tooltip(
        message: "Provides\nOnline Tuition",
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.headset_mic)
          ),
        ),
      );
    }else{
      return Tooltip(
        message: "Doesn't provide\nOnline Tuition",
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.headset_off)
          ),
        ),
      );
    }
  }

  Widget _buildIconIfWarranted(isWarranted){
    if(isWarranted){
      return Tooltip(
        message: "Tutor is\nCertified",
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.verified_user)
          ),
        ),
      );
    }else{
      return SizedBox();
    }
  }
}

Widget _buildBioWidget(tutorData){
  if(tutorData.bio != null){
    return Expanded(
      child: Card(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Text(tutorData.bio,
            style: TextStyle(
              color: greyPlus,
              fontSize: 16,
            ),
          )
        ),
      ),
    );
  }else{
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Text("No Bio to show",
        textAlign: TextAlign.center,
          style: TextStyle(
            color: greyPlus,
            fontSize: 20,
          ),
        )
      ),
    );
  }
}
Widget _buildTuitionWidget(tutorData){
   if(tutorData.tuition.length > 0){
    return  Container(
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(0,5,0,0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tutorData.tuition.length,
        itemBuilder: (context, index){

          final tuitionName = tutorData.tuition[index]['tuition_name'];
          final tuitionCategory = tutorData.tuition[index]['tuition_category'];
          final tuitionLevel = tutorData.tuition[index]['tuition_level'];
          final tuitionDescription = tutorData.tuition[index]['tuition_description'];
          final tuitionIsOnline = tutorData.tuition[index]['tuition_isOnline'];
          final isPremium = tutorData.isPremium;

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/book.png'),
              ),
              title: Text(tuitionName,
                style: TextStyle(color: isPremium? purplePlus : orangePlus),
              ),
              subtitle: Text('Subject: '+ tuitionCategory +'\nLevel: '+ tuitionLevel),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Icon(Icons.info,),
                    onTap: (){
                      _alertDialogTuitionInfo(
                        context: context, 
                        tuitionName: tuitionName, 
                        tuitionDescription: tuitionDescription, 
                        tuitionIsPremium: isPremium,
                        tuitionIsOnline: tuitionIsOnline,
                      );
                    },
                  ),
                ],
              ),
              isThreeLine: true
            ),
          );
        },
      ),
    );
  }else{
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Text("No tuitions to show",
        textAlign: TextAlign.center,
          style: TextStyle(
            color: greyPlus,
            fontSize: 20,
          ),
        )
      ),
    );
  }
}

Widget _buildReviewsWidget(tutorData){
  if(tutorData.reviews.length > 0){
    return Expanded(
      child: Container(
        width: double.infinity,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(0,5,0,0),
          itemCount: tutorData.reviews.length,
          itemBuilder: (context, index){

            final studentName = tutorData.reviews[index]['student_name'];
            final studentRating = tutorData.reviews[index]['student_rating'];
            final studentReview = tutorData.reviews[index]['student_review'];

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/profile-icon.jpg'),
                ),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(studentName,
                  style: TextStyle(color: blackPlus),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(studentReview)
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SmoothStarRating(
                            allowHalfRating: false,
                            starCount: 5,
                            rating: studentRating.toDouble(),
                            size: 20.0,
                            color: tutorData.isPremium? purplePlus : orangePlus,
                            borderColor: greyPlus,
                            spacing:0.0
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                isThreeLine: true
              ),
            );
          },
        ),
      ),
    );
  }else{
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Text("No reviews to show",
        textAlign: TextAlign.center,
          style: TextStyle(
            color: greyPlus,
            fontSize: 20,
          ),
        )
      ),
    );
  }
}

void _alertDialogTuitionInfo({BuildContext context, tuitionName, tuitionDescription, tuitionIsPremium, tuitionIsOnline}) {

  var alert = AlertDialog(
    title: Text(tuitionName,
      style: TextStyle(color: tuitionIsPremium ? purplePlus : orangePlus, fontWeight: FontWeight.bold, fontSize: 20),
    ),
    backgroundColor: whitePlus,
    content: RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
        children: [
          TextSpan(text: "Description: \n"),
          TextSpan(text: tuitionDescription,
            style: TextStyle(fontSize: 14)
          ),
        ],
      ),
    ),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon( tuitionIsOnline? Icons.headset_mic : Icons.headset_off,),
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
