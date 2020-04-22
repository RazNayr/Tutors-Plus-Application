import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'dart:async';

import 'package:tutorsplus/models/tuition.dart';
import 'package:tutorsplus/screens/search-view/tuition_tile.dart';
import 'package:tutorsplus/shared/category.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/locality.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  PanelController _pc = PanelController();
  ScrollController _scrollController = ScrollController();
  final GlobalKey<FormBuilderState> _filterKey = GlobalKey<FormBuilderState>();

  bool _mapReady = false;
  bool mapToggle = false;
  String _mapStyle;
  MapType _currentMapType = MapType.normal;

  int _selectedTuitionIndex = -1;
  var currentLocation;
  var _range = 5.0;
  var _zoom = 5.0;
  var _hideUI = false;
  var _sliderVisibility = false;
  var _radiusButtonVisibility = true;
  static var _localityFormInputVisibility = false;

  Map<String, Tuition> tuitions = <String, Tuition>{};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<Tuition> tuitionsOnMap = List<Tuition>();
  var mapDistances = Map();
  List<Tuition> premiumTuitionsOnMap = List<Tuition>();
  List<Tuition> freemiumTuitionsOnMap = List<Tuition>();
  List<Tuition> sortedTuitionsOnMap = List<Tuition>();
  Map<String, dynamic> _filter = <String, dynamic>{};
  Map<String, dynamic> _filterOnTuitions = {
    'level': null,
    'category': null,
    'locality': null
  };
  bool _noneAvailable = false;

  //took ages to make, want to be 100% sure we dont need before i delete it and its usage

  // final displacementMap = {
  //     // 14.0: 0.01440645109,
  //     // 13.5: 0.01962084775,
  //     // 13.0: 0.02680461575,
  //     // 12.5: 0.03870212761,
  //     // 12.25: 0.04536923163,
  //     // 12.0: 0.05585054236,
  //     // 11.75: 0.06396836297,
  //     // 11.5: 0.07543250084,
  //     // 11.3: 0.08662210988,
  //     // 11.2: 0.09334109119,
  //     // 11.0: 0.1110293887,
  //     // 10.8: 0.1298647664,
  //     // 10.6: 0.146582659,
  //     // 10.55: 0.1555412069,
  //     // 10.53: 0.149611895,
  //     // 10.49: 0.1617661812,
  //     // 10.42: 0.1657328531,
  //     // 10.36: 0.1713408965,
  //     // 10.30: 0.1793559496,
  //     // 10.24: 0.1868963114,
  //     // 10.17: 0.1932176468,
  //     // 10.10: 0.206095408,
  //     // 10.04: 0.2170894017,
  //     // 9.95: 0.2219217388,
  //     // 9.8: 0.2368946661,
  //   };

  Set<Circle> getCircleFromRadius() => Set<Circle>.from([
        Circle(
          circleId: CircleId('range_indicator'),
          center: LatLng(currentLocation.latitude, currentLocation.longitude),
          radius: _range * 1000,
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: whitePlus.withOpacity(0.8),
        ),
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _slidingPanel(context),
    );

    // return Scaffold(
    //   body: _slidingPanel(context),
    // );
    // print('ON MAP SCREEN');
    // return _slidingPanel(context);
  }

  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
        populateTuitions();
      });
    });
  }

  void populateTuitions() {
    Firestore.instance.collection('tuition').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
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
          tuitions[tuitionId] = newTuition;
          _addNewMarker(newTuition);
        }
      }
    });
  }

  void _addNewMarker(tuition) async {
    final MarkerId markerId = MarkerId(tuition.id);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(tuition.latitude, tuition.longitude),
      infoWindow: InfoWindow(title: tuition.name, snippet: tuition.tutor),
      icon: !tuition.isPremium
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      draggable: false,
      onTap: () => markerTap(tuition),
    );

    double distanceFromUser = await Geolocator().distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        tuition.latitude,
        tuition.longitude);
    distanceFromUser = distanceFromUser / 1000;

    setState(() {
      markers[markerId] = marker;
      mapDistances[markerId] = distanceFromUser;
    });
  }

  void markerTap(Tuition tuition) {
    scrollToTile(tuition);
    zoomOnMarker(tuition);
  }

  void scrollToTile(Tuition tuitionToScroll) {
    var whichTile = sortedTuitionsOnMap
        .indexWhere((tuition) => tuition.id == tuitionToScroll.id);

    setState(() => _selectedTuitionIndex = whichTile);

    print('tile to scroll to is: ' + whichTile.toString());

    var maxScrollValue = _scrollController.position.maxScrollExtent;
    var divisor = (maxScrollValue / tuitionsOnMap.length) + 20;
    var scrollToValue = whichTile * divisor;
    _scrollController.animateTo(scrollToValue,
        curve: Curves.easeIn, duration: Duration(milliseconds: 1000));
  }

  Future zoomOnMarker(Tuition tuition) async {
    GoogleMapController controller = await _controller.future;
    double _focusZoom = 17.0;
    controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(tuition.latitude, tuition.longitude),
        //LatLng(tuition.latitude - 0.001540481573, tuition.longitude),
        _focusZoom));
  }

  Set<Marker> updateRadiusFilter() {
    final zoomMap = {
      1: 14.0,
      2: 13.5,
      3: 13.0,
      4: 12.5,
      5: 12.25,
      6: 12.0,
      7: 11.75,
      8: 11.5,
      9: 11.3,
      10: 11.2,
      11: 11.0,
      12: 10.8,
      13: 10.6,
      14: 10.55,
      15: 10.53,
      16: 10.49,
      17: 10.42,
      18: 10.36,
      19: 10.30,
      20: 10.24,
      21: 10.17,
      22: 10.10,
      23: 10.04,
      24: 9.95,
      25: 9.8,
    };

    Map<MarkerId, Marker> markersToDisplay = <MarkerId, Marker>{};

    final withinRange = Map.from(mapDistances)
      ..removeWhere((k, v) => v > _range);

    List<dynamic> toRemove = [];
    toRemove.clear();
    withinRange.forEach((id, tuition) {
      bool nextIteration = false;

      //check properties against the filter
      if (_filterOnTuitions['level'] != tuitions[id.value].level &&
          _filterOnTuitions['level'] != null &&
          !nextIteration) {
        toRemove.add(id);
        nextIteration = true;
        print('level');
      }

      if (_filterOnTuitions['category'] != tuitions[id.value].category &&
          _filterOnTuitions['category'] != null &&
          !nextIteration) {
        toRemove.add(id);
        nextIteration = true;
        print('category');
      }

      if (_filterOnTuitions['locality'] != tuitions[id.value].locality &&
          _filterOnTuitions['locality'] != null &&
          !nextIteration) {
        toRemove.add(id);
        nextIteration = true;
        print('locality');
      }
    });

    withinRange.removeWhere((id, tuition) => toRemove.contains(id));
    //print('after filtering:' + withinRange.length.toString());

    if (withinRange.length == 0) {
      setState(() {
        _noneAvailable = true;
      });
    } else {
      _noneAvailable = false;
    }

    List<String> idsOnDisplay = List<String>();
    markers.forEach((markerId, details) {
      if (withinRange.containsKey(markerId)) {
        markersToDisplay[markerId] = details;
        idsOnDisplay.add(markerId.value.toString());
      }
    });

    //maybe optimize bro???
    tuitionsOnMap.clear();

    tuitions.forEach((id, tuition) {
      if (idsOnDisplay.contains(id) && !tuitionsOnMap.contains(tuition)) {
        tuitionsOnMap.add(tuition);
      }
    });

    premiumTuitionsOnMap.clear();
    freemiumTuitionsOnMap.clear();
    for (int i = 0; i < tuitionsOnMap.length; ++i) {
      if (tuitionsOnMap[i].isPremium == true) {
        premiumTuitionsOnMap.add(tuitionsOnMap[i]);
      } else {
        freemiumTuitionsOnMap.add(tuitionsOnMap[i]);
      }
    }

    sortedTuitionsOnMap.clear();
    sortedTuitionsOnMap.addAll(premiumTuitionsOnMap);
    sortedTuitionsOnMap.addAll(freemiumTuitionsOnMap);

    final zoom = zoomMap[_range];
    _zoom = zoom;

    return Set<Marker>.of(markersToDisplay.values);
  }

  Future rangeZoom() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(currentLocation.latitude, currentLocation.longitude), _zoom));
    // LatLng(currentLocation.latitude - displacementMap[_zoom],
    //     currentLocation.longitude),
    // _zoom));
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _currentLocationZoomAndAngle() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          bearing: 0,
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          //_radiusButtonVisibility
          // ? LatLng(currentLocation.latitude-displacementMap[_zoom], currentLocation.longitude)
          // : LatLng(currentLocation.latitude-displacementMap[14.0], currentLocation.longitude),
          // zoom: _radiusButtonVisibility
          // ? _zoom
          // : 14.0
          zoom: 14.0),
    ));
  }

  void _onCameraMove(CameraPosition position) {
    setState(() => _hideUI = true);
  }

  void _onCameraIdle() {
    setState(() => _hideUI = false);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;
    setState(() => _mapReady = true);
    mapController.setMapStyle(_mapStyle);
  }

  Widget _googleMap(BuildContext context) {
    return mapToggle
        ? GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(currentLocation.latitude - 0.04536923163,
                  currentLocation.longitude),
              zoom: 12.25,
            ),
            mapType: _currentMapType,
            minMaxZoomPreference: MinMaxZoomPreference(10.0, 20.0),
            cameraTargetBounds: CameraTargetBounds(LatLngBounds(
              southwest: LatLng(35.630512, 14.075246),
              northeast: LatLng(36.202174, 14.809208),
            )),
            markers: updateRadiusFilter(),
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            myLocationEnabled: true,
            tiltGesturesEnabled: false,
            //to be on top center
            padding: EdgeInsets.only(
              // right: MediaQuery.of(context).size.width / 2.4,
              bottom: MediaQuery.of(context).size.height / 1,
              top: MediaQuery.of(context).size.height / 2,
            ),
            circles: _radiusButtonVisibility ? getCircleFromRadius() : null,
          )
        : Center(
            child: Text(
            'Accessing your geolocation...',
            style: TextStyle(fontSize: 20.0),
          ));
  }

  Widget _radiusSlider(BuildContext context) {
    return _sliderVisibility
        ? Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            child: FlutterSlider(
              handler: FlutterSliderHandler(
                  child: Material(
                type: MaterialType.canvas,
                color: whitePlus,
                child: Container(
                  child: Icon(Icons.zoom_in, size: 18),
                ),
              )),
              trackBar: FlutterSliderTrackBar(
                  activeTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: whitePlus,
              )),
              tooltip: FlutterSliderTooltip(
                  textStyle: TextStyle(fontSize: 17, color: blackPlus),
                  boxStyle: FlutterSliderTooltipBox(
                      decoration:
                          BoxDecoration(color: whitePlus.withOpacity(0.7)))),
              axis: Axis.vertical,
              values: [_range],
              min: 1,
              max: 25,
              onDragging: (handlerIndex, lowerValue, upperValue) {
                setState(() {
                  _range = lowerValue;
                  _selectedTuitionIndex = -1;
                  updateRadiusFilter();
                  rangeZoom();
                });
              },
            ))
        : null;
  }

  void _radiusSliderVisibilityChange() {
    setState(() => _sliderVisibility = !_sliderVisibility);
  }

  void _radiusButtonVisibilityChange(bool toggled) {
    print('radius toggled');

    if (toggled) {
      setState(() {
        _radiusButtonVisibility = true;
        _range = 6;
        _zoom = 12.0;
      });
    } else {
      setState(() {
        _radiusButtonVisibility = false;
        _range = 60;
        _zoom = 9.8;
      });
    }

    if (_sliderVisibility) {
      setState(() => _sliderVisibility = false);
    }
  }

  Widget _tuitionListView(BuildContext context) {
    var listView = ListView.builder(
      itemCount: sortedTuitionsOnMap.length,
      controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {
        return TuitionTile(
            tuition: sortedTuitionsOnMap[index],
            premiumTuitionsCount: premiumTuitionsOnMap.length,
            currentIndex: index,
            selectedTuitionIndex: _selectedTuitionIndex);
      },
    );
    return _noneAvailable && _mapReady
        ? Container(
            child: Center(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 11,
                  padding: const EdgeInsets.all(20),
                  decoration: new BoxDecoration(
                      color: blackPlus,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      border: Border.all(color: amberPlus)),
                  child: Text(
                    'No tuitions found.',
                    style: TextStyle(
                      fontSize: 20,
                      color: whitePlus,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )),
          )
        : listView;
  }

  Widget _slidingPanel(BuildContext context) {
    return SlidingUpPanel(
      controller: _pc,
      panel: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              color: blackPlus,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: Icon(
              Icons.arrow_drop_down,
              size: 40,
              color: whitePlus,
            ),
          ),
          _filterForm(context),
        ],
      ),
      collapsed: Container(
        child: Icon(
          Icons.arrow_drop_up,
          size: 40,
          color: whitePlus,
        ),
        decoration: new BoxDecoration(
          color: blackPlus,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
      ),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      minHeight: 30,
      maxHeight: MediaQuery.of(context).size.height / 1.8,
      backdropEnabled: true,
      backdropColor: blackPlus,
      backdropOpacity: 0.75,
      body: _selectionView(context),
    );
  }

  void _applyFilter(Map<String, dynamic> _filter) {
    setState(() => _selectedTuitionIndex = -1);

    _filterOnTuitions['level'] = _filter['level'];
    _filterOnTuitions['category'] = _filter['category'];
    _filterOnTuitions['locality'] = _filter['locality'];

    _filterOnTuitions['level'] == 'Any'
        ? _filterOnTuitions['level'] = null
        : null;
    _filterOnTuitions['category'] == 'Any'
        ? _filterOnTuitions['category'] = null
        : null;
    _filterOnTuitions['locality'] == 'Any'
        ? _filterOnTuitions['locality'] = null
        : null;

    _radiusButtonVisibilityChange(_filter['radius']);
    _toggleLocalityFormVisibility(_filter['localityToggle']);
  }

  void _toggleLocalityFormVisibility(bool toggle) {
    if (toggle) {
      setState(() => _localityFormInputVisibility = true);
    } else {
      setState(() => _localityFormInputVisibility = false);
    }
  }

  // ValueChanged _onLocalityChanged = (val){
  //   _toggleLocalityFormVisibility(val);
  // };

  Widget _filterForm(BuildContext context) {
    List<String> categories = Category().getCategories();
    categories.insert(0, 'Any');
    List<String> localities = Locality().getLocalities();
    localities.insert(0, 'Any');

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      color: whitePlus,
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  child: const Icon(
                    Icons.cached,
                    size: 20.0,
                    color: greyPlus,
                  ),
                  onPressed: () {
                    _filterKey.currentState.reset();
                    setState(() => _localityFormInputVisibility = false);
                    if (_filterKey.currentState.saveAndValidate()) {
                      _filter = _filterKey.currentState.value;
                      _pc.close();
                      rangeZoom();
                      _applyFilter(_filter);
                    }
                  },
                  backgroundColor: whitePlus,
                  elevation: 0,
                  heroTag: 'hero2',
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text('Filters',
                    style: TextStyle(
                      color: blackPlus,
                      fontSize: 20,
                    )),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: FloatingActionButton(
                    child: const Icon(
                      Icons.done,
                      size: 20,
                      color: blackPlus,
                    ),
                    backgroundColor: whitePlus.withOpacity(1),
                    heroTag: 'hero1',
                    elevation: 0,
                    onPressed: () {
                      if (_filterKey.currentState.saveAndValidate()) {
                        _filter = _filterKey.currentState.value;
                        _pc.close();
                        rangeZoom();
                        _applyFilter(_filter);
                      }
                    }),
              ),
            ],
          ),
          Divider(),
          // SizedBox(height: 20),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.64,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: FormBuilder(
                    key: _filterKey,
                    child: Column(children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Column(
                            children: <Widget>[
                              FormBuilderCheckbox(
                                attribute: 'radius',
                                initialValue: true,
                                checkColor: whitePlus,
                                activeColor: amberPlus,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5)),
                                label: Text(
                                  'Radius',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              FormBuilderCheckbox(
                                  attribute: 'localityToggle',
                                  initialValue: false,
                                  checkColor: whitePlus,
                                  activeColor: amberPlus,
                                  //onChanged: _onLocalityChanged,
                                  label: Text(
                                    'Locality',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          //top: 5,
                                          bottom: 20))),
                              FormBuilderDropdown(
                                attribute: 'level',
                                //initialValue: 'Any',
                                hint: Text(
                                  'Select Level...',
                                  style:
                                      TextStyle(fontSize: 18, color: greyPlus),
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 30,
                                        bottom: 15)),
                                items: [
                                  'Any',
                                  'O\' Level',
                                  'Intermediate Level',
                                  'A\' Level'
                                ]
                                    .map((level) => DropdownMenuItem(
                                        value: level,
                                        child: Text("$level",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: amberPlus))))
                                    .toList(),
                              ),
                              FormBuilderDropdown(
                                attribute: 'category',
                                //initialValue: 'Any',
                                hint: Text(
                                  'Select Category...',
                                  style: TextStyle(fontSize: 18),
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5)),
                                items: categories
                                    .map((category) => DropdownMenuItem(
                                        value: category,
                                        child: Text("$category",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: amberPlus))))
                                    .toList(),
                              ),
                              _localityFormInputVisibility
                                  ? FormBuilderDropdown(
                                      attribute: 'locality',
                                      //initialValue: 'Any',
                                      hint: Text(
                                        'Select Locality...',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5)),
                                      items: localities
                                          .map((locality) => DropdownMenuItem(
                                              value: locality,
                                              child: Text("$locality",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: amberPlus))))
                                          .toList(),
                                    )
                                  : Container(),
                            ],
                          )),
                      Container(),
                    ])),
              )),
        ],
      ),
    );
  }


  //disable container attempt

  // bool touch = true;

  // void _onTap(){
  //   print('tap');
  //   setState(() {
  //     touch=false;
  //   });
  // }


  // void _onScaleStart(ScaleStartDetails details){
  //   print('drag start');
  //   setState(() {
  //     touch=true;
  //   });
  // }

  // void _onScaleEnd(ScaleEndDetails details){
  //   print('drag end');
  //   setState(() {
  //     touch=false;
  //   });
  // }

  Widget _selectionView(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: _googleMap(context),
        ),
        Positioned(
            //map button change
            top: MediaQuery.of(context).size.height / 20,
            left: MediaQuery.of(context).size.width / 35,
            child: Opacity(
              opacity: 0.8,
              child: FloatingActionButton(
                onPressed: _onMapTypeButtonPressed,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: blackPlus,
                elevation: 20,
                heroTag: 'hero3',
                mini: true,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: amberPlus)),
                child: const Icon(Icons.map, size: 18.0),
              ),
            )),
        Positioned(
            //map button change
            top: MediaQuery.of(context).size.height / 20,
            left: MediaQuery.of(context).size.width / 2.22,
            right: MediaQuery.of(context).size.width / 2.22,
            child: Opacity(
              opacity: 0.8,
              child: FloatingActionButton(
                onPressed: _currentLocationZoomAndAngle,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: blackPlus,
                elevation: 20,
                heroTag: 'hero4',
                mini: true,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: amberPlus)),
                child: const Icon(Icons.gps_fixed, size: 18.0),
              ),
            )),
        _radiusButtonVisibility
            ? Positioned(
                //radius vertical slider switch
                top: MediaQuery.of(context).size.height / 20,
                right: MediaQuery.of(context).size.width / 35,
                child: Opacity(
                  opacity: 0.8,
                  child: FloatingActionButton(
                    onPressed: _radiusSliderVisibilityChange,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: blackPlus,
                    elevation: 20,
                    heroTag: 'hero5',
                    mini: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: amberPlus)),
                    child: const Icon(Icons.arrow_drop_down_circle, size: 18.0),
                  ),
                ))
            : Container(),
        Positioned(
            top: MediaQuery.of(context).size.height / 12,
            right: MediaQuery.of(context).size.width / 110,
            bottom: MediaQuery.of(context).size.height / 1.5,
            child: Opacity(
              opacity: 0.8,
              child: _radiusSlider(context),
            )),
        Positioned(
            bottom: 30,
            right: 10,
            left: 10,
            top: (MediaQuery.of(context).size.height) / 2,
            child: Opacity(
              opacity: _hideUI ? 0.25 : 1,
              child: _tuitionListView(context),
              // child: GestureDetector(
              //   onTap: _onTap,
              //   onScaleStart: _onScaleStart,
              //   onScaleEnd: _onScaleEnd,
              //   child: IgnorePointer(
                  // ignoring: touch ? true : false,
                  // child: _tuitionListView(context),
              // ),
              // ),
            )),
      ],
    
    );
  }
}
