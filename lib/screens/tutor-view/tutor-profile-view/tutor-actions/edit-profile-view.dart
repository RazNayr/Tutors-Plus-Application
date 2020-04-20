import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tutorsplus/models/tutor.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/loading.dart';

class EditTutorProfile extends StatefulWidget {

  final TutorData tutorData;

  EditTutorProfile({this.tutorData});

  @override
  _EditTutorProfileState createState() => _EditTutorProfileState();
}

class _EditTutorProfileState extends State<EditTutorProfile> {
  
  double screenWidth;
  double screenHeight;
  List<String> _qualifications = new List();
  int _extraQualifications = 0;
  bool _loading = false;

  final _formBuilderKey = GlobalKey<FormBuilderState>();
  
  @override
  Widget build(BuildContext context) {

    final tutorData = widget.tutorData;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return _loading? (tutorData.isPremium? PremiumLoading() : Loading()) : Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: whitePlus,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child:FormBuilder(
          key: _formBuilderKey,
          autovalidate: false,

          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTitleCont(),
                SizedBox(height: 10),
                _buildImageCont(tutorData),
                SizedBox(height: 30),
                _buildIsOnlineCont(tutorData.isOnline),
                SizedBox(height: 10),
                _buildIsWarrantedCont(tutorData.isWarranted),
                SizedBox(height: 10),
                _buildQualificationsCont(tutorData.qualifications),
                SizedBox(height: 10),
                _buildBioCont(tutorData.bio),
                SizedBox(height: 10),
                _buildSaveCont(tutorData.uid, tutorData.qualifications),
            ]),
          ),
        )
      ),
        
    );
  }

  Widget _buildTitleCont(){
    return Container(
      child: Text(
        'Edit Tutor Profile',
        style: TextStyle(
          color: blackPlus,
          fontFamily: 'OpenSans',
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      )
    );
  }

  Widget _buildImageCont(tutorData){
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: tutorData.isPremium? purplePlus : orangePlus,
          backgroundImage: AssetImage('assets/tutor.png'),
          radius: screenWidth * 0.2,
        ),
        Container(
          width: screenWidth * 0.2 * 2,
          height: screenWidth * 0.2 * 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.add_a_photo, color: blackPlus,)
          ]),
        )
      ]
    );
  }

  Widget _buildIsOnlineCont(isOnline){
    return Card(
      child: FormBuilderCheckbox(
        attribute: 'isOnline_field',
        initialValue: isOnline,
        leadingInput: false,
        decoration: InputDecoration(
          border: InputBorder.none, 
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
        ),
        label: Text('Do you provide online tuition?',
          style: TextStyle(color: greyPlus,fontSize: 16,),
        ),
      ),
    );
  }

  Widget _buildIsWarrantedCont(isWarranted){
    return Card(
      child: FormBuilderCheckbox(
        attribute: 'isWarranted_field',
        initialValue: isWarranted,
        leadingInput: false,
        decoration: InputDecoration(
          border: InputBorder.none, 
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
        ),
        label: Text('Are you a warranted tutor?',
          style: TextStyle(color: greyPlus,fontSize: 16,),
        ),
      ),
    );
  }
  Widget _buildQualificationsCont(qualifications){

    final numQualifications = qualifications.length+_extraQualifications;

    return Column(
      children: <Widget>[

        Text(
          'Your Qualifications',
          style: TextStyle(
            color: blackPlus,
            fontFamily: 'OpenSans',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),

        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: numQualifications,

          itemBuilder: (context, index) {

            final String qualNum = (index+1).toString();

            if(index+1 >= numQualifications){
              if(index+1 <= qualifications.length){
                return Column(
                  children: <Widget>[
                    Card(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        color: Colors.white,
                        child: Text(qualifications[index]),
                      ),
                    ),
                    GestureDetector(
                      child: Icon(Icons.add_circle),
                      onTap: (){
                        setState(() {
                          _extraQualifications++;
                        });
                      },
                    )
                  ],
                );
              }else{
                return Column(
                  children: <Widget>[
                    Card(
                      child: Stack(
                        children: <Widget>[
                          FormBuilderTextField( 
                            autofocus: false,
                            attribute: 'qualification_field'+qualNum,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Qualification '+qualNum,
                              border: InputBorder.none, 
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            ),
                          ),

                          Positioned.fill(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal:10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Icon(Icons.remove_circle, color: Colors.grey,),
                                    onTap: (){
                                      setState(() {
                                        _extraQualifications--;

                                        FocusScopeNode currentFocus = FocusScope.of(context);
                                        currentFocus.unfocus();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Icon(Icons.add_circle),
                      onTap: (){
                        setState(() {
                          _extraQualifications++;
                        });
                      },
                    )
                  ],
                );
              }
            }else{ 
              if(index+1 <= qualifications.length){
                return Column(
                  children: <Widget>[
                    Card(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        color: Colors.white,
                        child: Text(qualifications[index]),
                      ),
                    ),
                    SizedBox(height: 10,)
                  ],
                );

              }else{
                return Column(
                  children: <Widget>[
                    Card(
                      child: Stack(
                        children: <Widget>[
                          FormBuilderTextField( 
                            autofocus: false,
                            attribute: 'qualification_field'+qualNum,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Qualification '+qualNum,
                              border: InputBorder.none, 
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            ),
                          ),

                          Positioned.fill(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal:10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Icon(Icons.remove_circle, color: Colors.grey,),
                                    onTap: (){
                                      setState(() {
                                        _extraQualifications--;

                                        FocusScopeNode currentFocus = FocusScope.of(context);
                                        currentFocus.unfocus();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10,)
                  ],
                );
              }
            }
          }
          
        ),
      ],
    );
  }

  Widget _buildBioCont(bio){
    return Card(
      child: FormBuilderTextField( 
        attribute: 'bio_field',
        maxLines: 4,
        initialValue: bio,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Brief Description about yourself...',
          border: InputBorder.none, 
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
        ),
      ),
    );
  }

  Widget _buildSaveCont(uid, previousQualifications){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 75),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: amberPlus,
        child: Text(
          'SAVE',
          style: TextStyle(
            color: whitePlus,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        onPressed: () async {
          if(_formBuilderKey.currentState.saveAndValidate()){
            setState(() {
              _loading = true;
              
              _qualifications = List.from(previousQualifications);
              int totalQualifications = previousQualifications.length + _extraQualifications;

              for(int i = previousQualifications.length; i < totalQualifications; i++){
                _qualifications.add(_formBuilderKey.currentState.value['qualification_field'+i.toString()]);
              }
            });

            await DatabaseService(uid: uid).updateTutorProfileDetails(
              _formBuilderKey.currentState.value['isOnline_field'],
              _formBuilderKey.currentState.value['isWarranted_field'],
              _formBuilderKey.currentState.value['bio_field'],
              _qualifications,
            );
            Navigator.pop(context);
          }
        }
      ),
    );
  }
}