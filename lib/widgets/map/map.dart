import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:eva/services/firebaseAuth.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:location/location.dart';

import 'package:eva/models/photoPost.dart';


class MapWidget extends StatefulWidget {

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(59.852, 39.211),
    zoom: 9.0,
  );

  MapboxMapController mapController;
  CameraPosition _position = _kInitialPosition;
  bool _isMoving = false;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  int _styleStringIndex = 0;
  List<String> _styleStrings = [MapboxStyles.MAPBOX_STREETS, MapboxStyles.SATELLITE, "assets/style.json"];
  List<String> _styleStringLabels = ["MAPBOX_STREETS", "SATELLITE", "LOCAL_ASSET"];
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = false;
  bool _telemetryEnabled = true;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;
  List<Object> _featureQueryFilter;

  LatLngBounds currentBbox;

  Circle _backgroundCircle;
  Symbol _selectedSymbol;
  Symbol _prevSelectedSymbol;

  @override
  initState() {
    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    mapController?.onSymbolTapped?.remove(onSymbolTapped);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      trackCameraPosition: true,
      compassEnabled: false,
      cameraTargetBounds: _cameraTargetBounds,
      minMaxZoomPreference: _minMaxZoomPreference,
      styleString: _styleStrings[_styleStringIndex],
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationTrackingMode: _myLocationTrackingMode,
      myLocationRenderMode: MyLocationRenderMode.NORMAL,
      onCameraIdle: _onCameraIdle,
      onMapClick: (point, latLng) async {
        // print("Map click: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
        // print("Filter $_featureQueryFilter");
        // List features = await mapController.queryRenderedFeatures(point, [], _featureQueryFilter);
        // if (features.length>0) {
        //   print(features[0]);
        // }
      },
      onMapLongClick: (point, latLng) async {
        // print("Map long press: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
      },
      // onCameraTrackingDismissed: () {
      //   this.setState(() {
      //     _myLocationTrackingMode = MyLocationTrackingMode.None;
      //   });
      // }
    );
    return new Scaffold(
      body: mapboxMap
    );
  }

  void _onCameraIdle() async {
    currentBbox = await mapController.getVisibleRegion();
    print(currentBbox);
  }

  void _onMapChanged() {
    setState(() {
    });
  }

  void onMapCreated(MapboxMapController controller) async{
    mapController = controller;
    // mapController.addListener(_onMapChanged);
    await moveToMyPosition();
    mapController.onSymbolTapped.add(onSymbolTapped);

    mapController.getTelemetryEnabled().then((isEnabled) =>
        setState(() {
          _telemetryEnabled = isEnabled;
        }));
    getPhotoPosts();
  }

  // CIRCLE API

  void _addCircle(CircleOptions options) async {
    _backgroundCircle = await mapController.addCircle(
      options
    );
    setState((){});
  }

  void _removeCircle(Circle circle) {
    mapController.removeCircle(circle);
    setState(() {
      _backgroundCircle = null;
    });
  }

  // SYMBOL API

  Future<void> _addImageFromUrl(String id, String url) async {
    var response = await get(url);
    return mapController.addImage(id, response.bodyBytes);
  }

  SymbolOptions _getSymbolOptions(String iconImage, LatLng coordinates){
    return SymbolOptions(
      geometry: coordinates,
      iconImage: iconImage
    );
  }

  //--------------

  //PUBLIC METHODS---------

  void addSymbol(String id, String imageUrl, LatLng coordinates) async{
    print('ADD');
    await _addImageFromUrl(id, imageUrl);
    await mapController.addSymbol(_getSymbolOptions(id, coordinates), {'id': id});
    setState(() {});
  }

  void updateSelectedSymbol(SymbolOptions changes) {
    mapController.updateSymbol(_selectedSymbol, changes);
  }

  void onSymbolTapped(Symbol symbol) {
    if (_selectedSymbol != null) {
        updateSelectedSymbol(
          const SymbolOptions(zIndex: 1),
        );
    }
    setState(() {
      _selectedSymbol = symbol;
      updateSelectedSymbol(
        const SymbolOptions(zIndex: 12),
      );
    });
    if (_backgroundCircle != null) {
      _removeCircle(_backgroundCircle);
    }
    CircleOptions circleOptions = new CircleOptions(
      geometry: symbol.options.geometry,
      circleColor: "white",
      circleRadius: 25,
      circleOpacity: 0,
      circleStrokeWidth: 4,
      circleStrokeColor: "blue",
      circleStrokeOpacity: 1
    );
    _addCircle(circleOptions);
  }

  void removeSymbol() {
    mapController.removeSymbols(mapController.symbols);
    setState(() {
      _selectedSymbol = null;
    });
  }

  void removeAllSymbols() {
    mapController.removeSymbols(mapController.symbols);
    setState(() {
      _selectedSymbol = null;
    });
  }
  
  //Set camera position
  void setCameraPosition(LatLng position) {
    mapController.moveCamera(CameraUpdate.newLatLng(position));
  }

  Future<void> moveToMyPosition() async{
    Location location = new Location();
    LocationData myLocation = await location.getLocation();
    LatLng latlng = LatLng(myLocation.latitude, myLocation.longitude);
    setCameraPosition(latlng);
  }

  //----------------------

  //PhotoPosts

  List<PhotoPost> photoPosts;

  Future<Response> _getPhotoPosts(url) async{
    var res = await get(url);
    return res;
  }

  void getPhotoPosts() async{
    String token;
    LatLngBounds latLngBounds = await mapController.getVisibleRegion();
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = 'http://192.168.2.232:8006/?idToken=${token}&swlng=${latLngBounds.southwest.longitude}&swlat=${latLngBounds.southwest.latitude}&nelng=${latLngBounds.northeast.longitude}&nelat=${latLngBounds.northeast.latitude}';
      _getPhotoPosts(url).then((res) {
        if (res.body != null) {
          photoPosts =(json.decode(res.body) as List).map((i) => PhotoPost.fromJson(i)).toList();
          for (var i in photoPosts) {
            addPhotoPostToMap(i);
          }
        }
      });
    });
  }

  void addPhotoPostToMap(PhotoPost photoPost) {
    LatLng coords = LatLng(photoPost.location.coordinates[1], photoPost.location.coordinates[0]);
    // addSymbol(photoPost.id, photoPost.imagesPaths + '/100circle.png', coords);
    addSymbol(photoPost.id, "https://storage.googleapis.com/pubphoto/2oB7ZukDeCVPBPSdkSYZxgH0Dj03/10d9b68c-ec46-4970-a139-e05f3ce359e1/100circle.png", coords);
  }
  //
}
