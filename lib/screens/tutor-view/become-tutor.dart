import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/loading.dart';

class BecomeTutor extends StatefulWidget {

  final Function toggleWelcomeView;

  BecomeTutor({this.toggleWelcomeView});

  @override
  _BecomeTutorState createState() => _BecomeTutorState();
}

class _BecomeTutorState extends State<BecomeTutor> {

  final _formBuilderKey = GlobalKey<FormBuilderState>();
  Map<String,dynamic> _tutorData = new Map();

  bool _loading = false;
  int _numQualifications = 1;

  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);
    final db = DatabaseService(uid: user.uid);
    
    return _loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: purplePlus,
        title: Text("Become a Tutor"),
        centerTitle: true,
      ),

      body: StreamBuilder<Object>(
        stream: db.userData,
        builder: (context, snapshot) {

          if(snapshot.hasData){
            final UserData userData = snapshot.data;

            return Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 30.0,
                ),
                child: Column(
                  children: [

                    //FORM FIELD
                    FormBuilder(
                      key: _formBuilderKey,
                      autovalidate: false,
                      child: Column(
                        children: <Widget>[
                          
                          Text(
                            'Personal Details',
                            style: TextStyle(
                              color: blackPlus,
                              fontFamily: 'OpenSans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 10),

                          FormBuilderCheckbox(
                            attribute: 'isWarranted_field',
                            initialValue: false,
                            leadingInput: false,
                            decoration: textInputDecoration,
                            label: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Are you a warranted tutor?\n',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: '(Optional)',
                                    style: TextStyle(
                                      color: greyPlus,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          FormBuilderCheckbox(
                            attribute: 'isOnline_field',
                            initialValue: false,
                            leadingInput: false,
                            decoration: textInputDecoration,
                            label: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Do you provide online tuition?\n',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: '(Optional)',
                                    style: TextStyle(
                                      color: greyPlus,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          FormBuilderCheckbox(
                            attribute: 'policeConduct_field',
                            initialValue: false,
                            leadingInput: false,
                            decoration: textInputDecoration,
                            label: RichText( 
                              text: TextSpan(
                                text: 'Please attach your recent police conduct.',
                                style: TextStyle(color: Colors.black),
                              )
                            ),
                            validators: [
                              FormBuilderValidators.requiredTrue(
                                errorText:"You must attach a valid police conduct for your registration.",
                              ),
                            ],
                          ),

                          SizedBox(height: 30),

                          Text(
                            'Your Qualifications',
                            style: TextStyle(
                              color: blackPlus,
                              fontFamily: 'OpenSans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 10),

                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _numQualifications,

                            itemBuilder: (context, index) {

                              final String qualNum = (index+1).toString();

                              if(index+1 == _numQualifications){
                                if(index != 0){
                                  return Column(
                                    children: <Widget>[
                                      FormBuilderTextField( 
                                        autofocus: false,
                                        attribute: 'qualification_field'+qualNum,
                                        maxLines: 1,
                                        decoration: textInputDecoration.copyWith(
                                          hintText: 'Qualification '+qualNum, 
                                          suffixIcon: GestureDetector(
                                            child:Icon(Icons.remove_circle),
                                            onTap: (){
                                              setState(() {
                                                _numQualifications--;
                                              });
                                            },
                                          )
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Icon(Icons.add_circle),
                                        onTap: (){
                                          setState(() {
                                            _numQualifications++;
                                          });
                                        },
                                      )
                                    ],
                                  );
                                }else{
                                  return Column(
                                    children: <Widget>[
                                      FormBuilderTextField( 
                                        autofocus: false,
                                        attribute: 'qualification_field'+qualNum,
                                        maxLines: 1,
                                        decoration: textInputDecoration.copyWith(
                                          hintText: 'Qualification '+qualNum,
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Icon(Icons.add_circle),
                                        onTap: (){
                                          setState(() {
                                            _numQualifications++;
                                          });
                                        },
                                      )
                                    ],
                                  );
                                }
                                
                              }else{ 
                                if(index != 0){
                                  return Column(
                                    children: <Widget>[
                                      FormBuilderTextField( 
                                        autofocus: false,
                                        attribute: 'qualification_field'+qualNum,
                                        maxLines: 1,
                                        decoration: textInputDecoration.copyWith(
                                          hintText: 'Qualification '+qualNum, 
                                          suffixIcon: GestureDetector(
                                            child:Icon(Icons.remove_circle),
                                            onTap: (){
                                              setState(() {
                                                _numQualifications--;
                                              });
                                            },
                                          )
                                        ),
                                      ),
                                      SizedBox(height:10)
                                    ],
                                  );
                                }else{
                                  return Column(
                                    children: <Widget>[
                                      FormBuilderTextField( 
                                        autofocus: false,
                                        attribute: 'qualification_field'+qualNum,
                                        maxLines: 1,
                                        decoration: textInputDecoration.copyWith(hintText: 'Qualification '+qualNum),
                                      ),
                                      SizedBox(height:10)
                                    ],
                                  );
                                }
                              }
                            }
                            
                          ),

                        ]
                      )
                    ),

                    //SUBMIT BUTTON
                    Container(
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
                        onPressed: () {
                          if(_formBuilderKey.currentState.saveAndValidate()){
                            setState(() {
                              _loading = true;
                              bool isOnline = _formBuilderKey.currentState.value['isOnline_field'];
                              bool isWarranted = _formBuilderKey.currentState.value['isWarranted_field'];
                              List<String> qualifications = new List();

                              for(int i = 1; i <= _numQualifications; i++){
                                qualifications.add(_formBuilderKey.currentState.value['qualification_field'+i.toString()]);
                              }

                              _tutorData['fname'] = userData.fname;
                              _tutorData['lname'] = userData.lname;
                              _tutorData['dob'] = userData.dob.toDate();
                              _tutorData['isOnline'] = isOnline;
                              _tutorData['isWarranted'] = isWarranted;
                              _tutorData['qualifications'] = qualifications;

                            });
                            
                            //Await isn't used here so that Welcome view can be immediately viewed before stream changes the view itself.
                            db.initialiseTutor(_tutorData);
                            widget.toggleWelcomeView();
                          }
                        }
                      ),
                    ),
                  ],
                ),
              ),
            );
          }else{
            return Loading();
          }
        }
      ),
    );
  }
}