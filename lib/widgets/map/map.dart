import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:eva/config.dart';
import 'package:eva/services/firebaseAuth.dart';
import 'package:eva/models/photoPost.dart';

class MapWidget extends StatefulWidget {
  final symbolClickCallBack;
  MapWidget({Key key, this.symbolClickCallBack}) : super(key: key);

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(51.852, 39.211),
    zoom: 13.0,
  );

  MapboxMapController mapController;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  int _styleStringIndex = 0;
  List<String> _styleStrings = [
    MapboxStyles.MAPBOX_STREETS,
    MapboxStyles.SATELLITE,
  ];
  bool _rotateGesturesEnabled = false;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = false;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;
  LatLngBounds currentBbox;

  Symbol _selectedSymbol;

  StreamSubscription<Position> positionStream;

  double deltaLat = 1.0;
  double deltaLng = 1.0;

  Timer _timer;

  @override
  initState() {
    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    mapController?.onSymbolTapped?.remove(onSymbolTapped);
    positionStream.cancel();
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
      onMapClick: (point, latLng) async {},
      onMapLongClick: (point, latLng) async {},
    );
    return new Scaffold(body: mapboxMap);
  }

  void _onCameraIdle() async {
    LatLngBounds newBbox = await mapController.getVisibleRegion();
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(seconds: 1), () {
      if (currentBbox != null) {
        deltaLat =
            ((newBbox.northeast.latitude - currentBbox.northeast.latitude) /
                    (currentBbox.northeast.latitude -
                        currentBbox.southwest.latitude))
                .abs();
        deltaLng =
            ((newBbox.northeast.longitude - currentBbox.northeast.longitude) /
                    (currentBbox.northeast.longitude -
                        currentBbox.southwest.longitude))
                .abs();
      }
      currentBbox = newBbox;
      if (deltaLat >= 0.2 || deltaLng >= 0.3) {
        removeAllSymbols();
        Timer(Duration(milliseconds: 200), () {
          getPhotoPosts();
        });
      }
    });
  }

  void onMapCreated(MapboxMapController controller) async {
    mapController = controller;
    mapController.setTelemetryEnabled(false);
    // mapController.addListener(_onMapChanged);
    mapController.onSymbolTapped.add(onSymbolTapped);
    moveToLastKnownLocation();
    getPhotoPosts();
  }

  Future<void> _addImageFromUrl(String id, String url) async {
    var response = await get(url);
    return mapController.addImage(id, response.bodyBytes);
  }

  SymbolOptions _getSymbolOptions(String iconImage, LatLng coordinates) {
    return SymbolOptions(geometry: coordinates, iconImage: iconImage);
  }

  // ------------------

  //PUBLIC METHODS---------

  void addSymbol(
      String id, String imageUrl, LatLng coordinates, Map data) async {
    await _addImageFromUrl(id, imageUrl);
    print(data);
    await mapController.addSymbol(_getSymbolOptions(id, coordinates), data);
  }

  void updateSelectedSymbol(SymbolOptions changes) {
    mapController.updateSymbol(_selectedSymbol, changes);
  }

  void onSymbolTapped(Symbol symbol) {
    widget.symbolClickCallBack(symbol.data);
    if (_selectedSymbol != null) {
      updateSelectedSymbol(
        const SymbolOptions(zIndex: 1, iconSize: 1),
      );
    }
    setState(() {
      _selectedSymbol = symbol;
      updateSelectedSymbol(
        const SymbolOptions(zIndex: 12, iconSize: 1.4),
      );
    });
  }

  void removeSymbol() {
    mapController.removeSymbols(mapController.symbols);
    setState(() {
      _selectedSymbol = null;
    });
  }

  void removeAllSymbols() {
    if (mapController.symbols.length > 0) {
      mapController.removeSymbols(mapController.symbols);
    }
    setState(() {
      _selectedSymbol = null;
    });
  }

  //Set camera position
  void moveCameraPosition(LatLng position) {
    mapController.moveCamera(CameraUpdate.newLatLng(position));
  }

  void animateCameraPosition(LatLng position) {
    mapController.animateCamera(CameraUpdate.newLatLng(position));
  }

  void moveToLastKnownLocation() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      LatLng latlng = LatLng(position.latitude, position.longitude);
      moveCameraPosition(latlng);
    } else {
      Geolocator geolocator = Geolocator();
      Position position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng latlng = LatLng(position.latitude, position.longitude);
      moveCameraPosition(latlng);
    }
  }

  //----------------------

  //PhotoPosts

  List<PhotoPost> photoPosts;

  Future<Response> _getPhotoPosts(url) async {
    var res = await get(url);
    return res;
  }

  void getPhotoPosts() async {
    String token;
    LatLngBounds latLngBounds = await mapController.getVisibleRegion();
    print("GET");
    print(latLngBounds);
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['getPhoto'] +
          '?idToken=${token}&swlng=${latLngBounds.southwest.longitude}&swlat=${latLngBounds.southwest.latitude}&nelng=${latLngBounds.northeast.longitude}&nelat=${latLngBounds.northeast.latitude}';
      print(url);
      _getPhotoPosts(url).then((res) {
        print(res.body);
        if (res.body != null && res.body != 'null') {
          photoPosts = (json.decode(res.body) as List)
              .map((i) => PhotoPost.fromJson(i))
              .toList();
          for (var i in photoPosts) {
            addPhotoPostToMap(i);
          }
        }
      }).catchError((error) {
        print("NOT OK");
        print(error);
      });
    });
  }

  void addPhotoPostToMap(PhotoPost photoPost) {
    LatLng coords = LatLng(
        photoPost.location.coordinates[1], photoPost.location.coordinates[0]);
    var data = {
      'id': photoPost.id,
      'imagesPaths': photoPost.imagesPaths,
      'description': photoPost.description,
      'userId': photoPost.userId,
      'favorites': photoPost.favorites
    };
    print(config.urls['media'] + photoPost.imagesPaths + "/100circle.png");
    addSymbol(
        photoPost.id,
        config.urls['media'] + photoPost.imagesPaths + "/100circle.png",
        coords,
        data);
  }
}
