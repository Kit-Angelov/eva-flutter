import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:eva/services/firebaseAuth.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:eva/models/photoPost.dart';


class MapWidget extends StatefulWidget {

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(-33.852, 151.211),
    zoom: 11.0,
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
  bool _myLocationEnabled = true;
  bool _telemetryEnabled = true;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;

  LatLngBounds currentBbox;

  Symbol _selectedSymbol;

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
        print(res);
        photoPosts =(json.decode(res.body) as List).map((i) => PhotoPost.fromJson(i)).toList();
        print(photoPosts);
      });
    });
  }

  @override
  initState() {
    super.initState();
    setState(() {});
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
        print("Map click: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
      },
      onMapLongClick: (point, latLng) async {
        print("Map long press: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
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
    moveToMyPosition();

    mapController.getTelemetryEnabled().then((isEnabled) =>
        setState(() {
          _telemetryEnabled = isEnabled;
        }));
    getPhotoPosts();
  }


  // SYMBOL API

  Future<void> _addImageFromUrl(String id, String url) async {
    var response = await get(url);
    return mapController.addImage(id, response.bodyBytes);
  }

  SymbolOptions _getSymbolOptions(String iconImage, LatLng coordinates){
    return SymbolOptions(
      geometry: coordinates,
      iconImage: iconImage,
    );
  }

  //--------------

  //PUBLIC METHODS---------

  void addSymbol(String id, String imageUrl, LatLng coordinates) async{
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
        const SymbolOptions(iconSize: 1.0),
      );
    }
    setState(() {
      _selectedSymbol = symbol;
    });
    updateSelectedSymbol(
      SymbolOptions(
        iconSize: 1.4,
      ),
    );
  }

  void removeSymbol() {
    mapController.removeSymbol(_selectedSymbol);
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

  void moveToMyPosition() async{
    LatLng myLocation = await mapController.requestMyLocationLatLng();
    setCameraPosition(myLocation);
  }

  //----------------------
}
