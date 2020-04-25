import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tutorsplus/models/tutor.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/category.dart' as categoryclass;
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
  Map<String, dynamic> _tuitionData = new Map();
  List<String> _currentTuitionDetails = new List();
  bool _loading = false;

  final _categories = categoryclass.Category().getCategories();
  final _localities = Locality().getLocalities();

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  String _mapStyle;
  LatLng _centralPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool isPlaced = false;
  double markerToSubmitLat = 0.0;
  double markerToSubmitLong = 0.0;

  void _alertDialogExistingTuition(BuildContext context) {
    var alert = AlertDialog(
      title: Text(
        "You have already created a tuition with the same level and category.",
        style: TextStyle(color: greyPlus, fontWeight: FontWeight.bold),
      ),
      backgroundColor: whitePlus,
      content: Text(
        "Try changing these values to create your new tuition!",
        style: TextStyle(
            fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Ok",
              style: TextStyle(
                  fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
            )),
      ],
      elevation: 20.0,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
      barrierDismissible: true,
    );
  }

  void _alertDialogNoGeopoint(BuildContext context) {
    var alert = AlertDialog(
      title: Text(
        "No marker was added on the map.",
        style: TextStyle(color: greyPlus, fontWeight: FontWeight.bold),
      ),
      backgroundColor: whitePlus,
      content: Text(
        "Please add a marker so others can know where your tuition is situated!",
        style: TextStyle(
            fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Ok",
              style: TextStyle(
                  fontSize: 16, color: greyPlus, fontWeight: FontWeight.bold),
            )),
      ],
      elevation: 20.0,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
      barrierDismissible: true,
    );
  }

  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  void _onCameraMove(CameraPosition position) {
    setState(() => _centralPosition =
        LatLng(position.target.latitude, position.target.longitude));
  }

  void _addMarker() {
    final MarkerId markerId = MarkerId('temp_marker');

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(_centralPosition.latitude, _centralPosition.longitude),
      // @ryan: if tutor is premium, handle this switch
      icon: widget.tutorData.isPremium
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      draggable: false,
      //onTap: () => print(marker.position),
    );

    setState(() {
      markers[markerId] = marker;
      isPlaced = true;
      markerToSubmitLat = marker.position.latitude;
      markerToSubmitLong = marker.position.longitude;
    });
  }

  Set<Marker> _getMarker() {
    return Set<Marker>.of(markers.values);
  }

  @override
  Widget build(BuildContext context) {
    final _tutorData = widget.tutorData;
    final _db = DatabaseService(uid: _tutorData.uid);

    for (int i = 0; i < _tutorData.tuition.length; i++) {
      String tuitionDetails = _tutorData.tuition[i]['tuition_level'] +
          _tutorData.tuition[i]['tuition_category'];
      _currentTuitionDetails.add(tuitionDetails);
    }

    return _loading 
    ? AddingTuition(isPremium: _tutorData.isPremium,) 
    : Scaffold(
      appBar: AppBar(
        backgroundColor: _tutorData.isPremium ? purplePlus : orangePlus,
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
                        child: Column(children: <Widget>[
                          Text(
                            'Tuition Map Position',
                            style: TextStyle(
                              color: blackPlus,
                              fontFamily: 'OpenSans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 30),

                          Text(
                            'Drag & pinch the map to move the marker to the location of your tuition.',
                            style: TextStyle(
                              color: greyPlus,
                              fontFamily: 'OpenSans',
                              fontSize: 9.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Container(
                              child: Stack(
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width / 1.2,
                                child: GoogleMap(
                                  gestureRecognizers:
                                      <Factory<OneSequenceGestureRecognizer>>[
                                    new Factory<OneSequenceGestureRecognizer>(
                                      () => new EagerGestureRecognizer(),
                                    ),
                                  ].toSet(),
                                  onMapCreated: _onMapCreated,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(35.913523, 14.401827),
                                    zoom: 9.5,
                                  ),
                                  minMaxZoomPreference:
                                      MinMaxZoomPreference(10.0, 20.0),
                                  cameraTargetBounds:
                                      CameraTargetBounds(LatLngBounds(
                                    southwest: LatLng(35.630512, 14.075246),
                                    northeast: LatLng(36.202174, 14.809208),
                                  )),
                                  onCameraMove: _onCameraMove,
                                  myLocationEnabled: true,
                                  markers: _getMarker(),
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  child: Image.asset('assets/marker.png'),
                                ),
                                left: 120,
                                right: 120,
                                bottom: 140,
                                top: 100,
                              )
                            ],
                          )),

                          SizedBox(height: 30),

                          RaisedButton(
                            elevation: 5.0,
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: amberPlus,
                            child: !isPlaced
                                ? Text(
                                    'Place Marker',
                                    style: TextStyle(
                                      color: whitePlus,
                                      letterSpacing: 1.5,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    ),
                                  )
                                : Text(
                                    'Replace Marker',
                                    style: TextStyle(
                                      color: whitePlus,
                                      letterSpacing: 1.5,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                            onPressed: _addMarker,
                          ),

                          SizedBox(height: 50),

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
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: "Tuition name required")
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
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10)),
                              items: [
                                'O\' Level',
                                'Intermediate Level',
                                'A\' Level'
                              ]
                                  .map((level) => DropdownMenuItem(
                                      value: level,
                                      child: Text("$level",
                                          style: TextStyle(fontSize: 16))))
                                  .toList(),
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: "Education Level required"),
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
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10)),
                              items: _categories
                                  .map((category) => DropdownMenuItem(
                                      value: category,
                                      child: Text("$category",
                                          style: TextStyle(fontSize: 16))))
                                  .toList(),
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: "Category required"),
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
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10)),
                              items: _localities
                                  .map((locality) => DropdownMenuItem(
                                      value: locality,
                                      child: Text("$locality",
                                          style: TextStyle(fontSize: 16))))
                                  .toList(),
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: "Locality required"),
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
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10)),
                              label: Text(
                                'Can this tuition be provided online?',
                                style: TextStyle(
                                  color: greyPlus,
                                  fontSize: 16,
                                ),
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
                                  hintText:
                                      'Brief Description of your Tuition...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20)),
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: "Short Description required")
                              ],
                            ),
                          ),

                          SizedBox(height: 20),
                        ])),

                    //SUBMIT BUTTON
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 75),
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
                            if (_formBuilderKey.currentState
                                .saveAndValidate()) {
                              String level = _formBuilderKey
                                  .currentState.value['level_field'];
                              String category = _formBuilderKey
                                  .currentState.value['category_field'];
                              String newTuitionDetails = level + category;

                              if (markerToSubmitLat == 0.0 &&
                                  markerToSubmitLong == 0.0) {
                                _alertDialogNoGeopoint(context);
                                print('no geopoint found');
                              } else {
                                //Check if tuition was already created by the Tutor
                                if (_currentTuitionDetails
                                    .contains(newTuitionDetails)) {
                                  _alertDialogExistingTuition(context);
                                } else {
                                  setState(() {
                                    _loading = true;
                                    bool isOnline = _formBuilderKey
                                        .currentState.value['isOnline_field'];
                                    String name = _formBuilderKey
                                        .currentState.value['name_field'];
                                    String level = _formBuilderKey
                                        .currentState.value['level_field'];
                                    String category = _formBuilderKey
                                        .currentState.value['category_field'];
                                    String locality = _formBuilderKey
                                        .currentState.value['locality_field'];
                                    String description = _formBuilderKey
                                        .currentState
                                        .value['description_field'];

                                    _tuitionData['name'] = name;
                                    _tuitionData['level'] = level;
                                    _tuitionData['category'] = category;
                                    _tuitionData['locality'] = locality;
                                    _tuitionData['description'] = description;
                                    _tuitionData['isOnline'] = isOnline;
                                    _tuitionData['isPremium'] =
                                        _tutorData.isPremium;
                                    _tuitionData['tutor'] = _tutorData.fname +
                                        " " +
                                        _tutorData.lname;
                                    _tuitionData['geopoint'] = new GeoPoint(
                                        markerToSubmitLat, markerToSubmitLong);
                                  });

                                  await new Future.delayed(
                                      const Duration(seconds: 4));
                                  await _db.initialiseTuition(_tuitionData);
                                  Navigator.pop(context);
                                }
                              }
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
