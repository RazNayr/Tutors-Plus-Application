import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tutorsplus/models/tutor.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/category.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/locality.dart';

import '../add-tuition-loading.dart';

class AddTuition extends StatefulWidget {

  final TutorData tutorData;

  AddTuition({this.tutorData});

  @override
  _AddTuitionState createState() => _AddTuitionState();
}

class _AddTuitionState extends State<AddTuition> {

  final _formBuilderKey = GlobalKey<FormBuilderState>();
  Map<String,dynamic> _tuitionData = new Map();
  List<String> _currentTuitionDetails = new List();
  bool _loading = false;

  final _categories = Category().getCategories();
  final _localities = Locality().getLocalities();

  void _alertDialogExistingTuition(BuildContext context) {
    var alert = AlertDialog(
      title: Text("You have already created a tuition with the same level and category.",
        style: TextStyle(color: greyPlus, fontWeight: FontWeight.bold),
      ),
      backgroundColor: whitePlus,
      content: Text("Try changing these values to create your new tuition!",
        style: TextStyle(fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context), 
          child: Text("Ok",
            style: TextStyle(
              fontSize: 16,
              color: greyPlus,
              fontWeight: FontWeight.bold
            ),
          )
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

  @override
  Widget build(BuildContext context) {
    
    final _tutorData = widget.tutorData;
    final _db = DatabaseService(uid: _tutorData.uid);
    double longitude = 0.0;
    double latitude = 0.0;

    for(int i = 0; i < _tutorData.tuition.length; i++){
      String tuitionDetails = _tutorData.tuition[i]['tuition_level']+_tutorData.tuition[i]['tuition_category'];
      _currentTuitionDetails.add(tuitionDetails);
    }
    
    return _loading ? AddingTuition() : Scaffold(
      appBar: AppBar(
        backgroundColor: orangePlus,
        title: Text("Add Tuition"),
        centerTitle: true,
      ),

      body: Container(
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
                      'Tuition Map Position',
                      style: TextStyle(
                        color: blackPlus,
                        fontFamily: 'OpenSans',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    //CICCIO POGGI MAP HAWN HAQQ AL MADOOOO
                    Container(),
                    
                    SizedBox(height: 20),

                    Text(
                      'Tuition Details',
                      style: TextStyle(
                        color: blackPlus,
                        fontFamily: 'OpenSans',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Card(
                      child: FormBuilderTextField( 
                        attribute: 'name_field',
                        maxLines: 1,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Name of your Tuition...',
                          border: InputBorder.none, 
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                        ),
                        validators: [
                          FormBuilderValidators.required(errorText: "Tuition name required")
                        ],
                      ),
                    ),

                    SizedBox(height: 10),

                    Card(
                      child: FormBuilderDropdown(
                        attribute: 'level_field',
                        hint: Text(
                          'Select Level...',
                          style: TextStyle(fontSize: 16),
                          ),
                        decoration: InputDecoration(
                          border: InputBorder.none, 
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                        ),
                        items: ['Any','O\' level', 'Intermediate Level', 'A\' level']
                          .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text("$level", style: TextStyle(fontSize: 16))
                          )).toList(),
                        validators: [
                          FormBuilderValidators.required(errorText: "Education Level required"),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),

                    Card(
                      child: FormBuilderDropdown(
                        attribute: 'category_field',
                        hint: Text(
                          'Select Category...',
                          style: TextStyle(fontSize: 16),
                          ),
                        decoration: InputDecoration(
                          border: InputBorder.none, 
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                        ),
                        items: _categories
                          .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text("$category", style: TextStyle(fontSize: 16))
                          )).toList(),
                        validators: [
                          FormBuilderValidators.required(errorText: "Category required"),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),

                    Card(
                      child: FormBuilderDropdown(
                        attribute: 'locality_field',
                        hint: Text(
                          'Select Locality...',
                          style: TextStyle(fontSize: 16),
                          ),
                        decoration: InputDecoration(
                          border: InputBorder.none, 
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                        ),
                        items: _localities
                          .map((locality) => DropdownMenuItem(
                            value: locality,
                            child: Text("$locality", style: TextStyle(fontSize: 16))
                          )).toList(),
                        validators: [
                          FormBuilderValidators.required(errorText: "Locality required"),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),

                    Card(
                      child: FormBuilderCheckbox(
                        attribute: 'isOnline_field',
                        initialValue: false,
                        leadingInput: false,
                        decoration: InputDecoration(
                          border: InputBorder.none, 
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                        ),
                        label: Text('Can this tuition be provided online?',
                          style: TextStyle(color: greyPlus,fontSize: 16,),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    Card(
                      child: FormBuilderTextField( 
                        attribute: 'description_field',
                        maxLines: 4,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Brief Description of your Tuition...',
                          border: InputBorder.none, 
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                        ),
                        validators: [
                          FormBuilderValidators.required(errorText: "Short Description required")
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

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
                    'Add Tuition',
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

                      String level = _formBuilderKey.currentState.value['level_field'];
                      String category = _formBuilderKey.currentState.value['category_field'];
                      String newTuitionDetails = level+category;

                      //Check if tuition was already created by the Tutor
                      if(_currentTuitionDetails.contains(newTuitionDetails)){
                        _alertDialogExistingTuition(context);
                      }else{
                        setState(() {
                        _loading = true;
                        bool isOnline = _formBuilderKey.currentState.value['isOnline_field'];
                        String name = _formBuilderKey.currentState.value['name_field'];
                        String level = _formBuilderKey.currentState.value['level_field'];
                        String category = _formBuilderKey.currentState.value['category_field'];
                        String locality = _formBuilderKey.currentState.value['locality_field'];
                        String description = _formBuilderKey.currentState.value['description_field'];

                        _tuitionData['name'] = name;
                        _tuitionData['level'] = level;
                        _tuitionData['category'] = category;
                        _tuitionData['locality'] = locality;
                        _tuitionData['description'] = description;
                        _tuitionData['isOnline'] = isOnline;
                        _tuitionData['isPremium'] = _tutorData.isPremium;
                        _tuitionData['tutor'] = _tutorData.fname+" "+_tutorData.lname;
                        _tuitionData['geopoint'] = new GeoPoint(longitude,latitude);
                      });
                      
                      await new Future.delayed(const Duration(seconds : 4));
                      await _db.initialiseTuition(_tuitionData);
                      Navigator.pop(context);
                      }
                      
                    }
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
