import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'dart:math';
import 'package:eva/models/profile.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
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
  Map<String, String> _styleStrings = {
    'Dark': MapboxStyles.DARK,
    'Light': MapboxStyles.LIGHT,
    'Outdoors': MapboxStyles.OUTDOORS,
    'Sattelite': MapboxStyles.SATELLITE,
  };
  String currentStyleItem = 'Dark';
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = false;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;
  LatLngBounds currentBbox;

  Symbol _selectedSymbol;

  // StreamSubscription<Position> positionStream;

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
    // positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      trackCameraPosition: true,
      compassEnabled: true,
      compassViewPosition: CompassViewPosition.BottomLeft,
      compassViewMargins: Point(15, 100),
      cameraTargetBounds: _cameraTargetBounds,
      minMaxZoomPreference: _minMaxZoomPreference,
      styleString: _styleStrings[currentStyleItem],
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
    return new Scaffold(
        body: Stack(
      children: [
        mapboxMap,
        Positioned(
          top: 250,
          left: 5,
          child: Opacity(
            opacity: 0.9,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white38, width: 0),
                color: Color.fromRGBO(44, 62, 80, 1),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  mapController.animateCamera(
                    CameraUpdate.zoomIn(),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 300,
          left: 5,
          child: Opacity(
            opacity: 0.9,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white38, width: 0),
                  color: Color.fromRGBO(44, 62, 80, 1),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: IconButton(
                icon: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                onPressed: () {
                  mapController.animateCamera(
                    CameraUpdate.zoomOut(),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 370,
          left: 5,
          child: Opacity(
            opacity: 0.9,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white38, width: 0),
                  color: Color.fromRGBO(44, 62, 80, 1),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: IconButton(
                icon: Icon(
                  Icons.layers,
                  color: Colors.white,
                ),
                onPressed: _selectLayer,
              ),
            ),
          ),
        ),
      ],
    ));
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
  void moveCameraPosition(LatLng position, {double zoom: 0}) {
    if (zoom != 0) {
      mapController.moveCamera(
        CameraUpdate.newLatLngZoom(position, zoom),
      );
    } else {
      mapController.moveCamera(CameraUpdate.newLatLng(position));
    }
  }

  void animateCameraPosition(LatLng position, {double zoom: 0}) {
    if (zoom != 0) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(position, zoom),
      );
    } else {
      mapController.animateCamera(CameraUpdate.newLatLng(position));
    }
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

  void getPhotoPosts({Profile profile}) async {
    String token;
    LatLngBounds latLngBounds = await mapController.getVisibleRegion();
    print("GET");
    print(latLngBounds);
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['getPhoto'] +
          '?idToken=${token}&swlng=${latLngBounds.southwest.longitude}&swlat=${latLngBounds.southwest.latitude}&nelng=${latLngBounds.northeast.longitude}&nelat=${latLngBounds.northeast.latitude}';
      if (profile != null) {
        url = url + '&userid=${profile.userId}';
      }
      _getPhotoPosts(url).then((res) {
        print(res.body);
        if (res.body != null && res.body != 'null') {
          photoPosts = (json.decode(utf8.decode(res.bodyBytes)) as List)
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
    var data = photoPost.toJson();
    addSymbol(
        photoPost.id,
        config.urls['media'] + photoPost.imagesPaths + "/100circle.png",
        coords,
        data);
  }

  // select map layers

  void _selectLayer() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: _bottomSheetSelectLayer(),
            height: 240,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                )),
          );
        });
  }

  Column _bottomSheetSelectLayer() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.check_circle_outline,
            color: currentStyleItem == 'Dark'
                ? Colors.pink.shade600
                : Colors.grey[300],
          ),
          title: Text('Dark'),
          onTap: () {
            _setMapStyle('Dark');
          },
        ),
        ListTile(
          leading: Icon(
            Icons.check_circle_outline,
            color: currentStyleItem == 'Light'
                ? Colors.pink.shade600
                : Colors.grey[300],
          ),
          title: Text('Light'),
          onTap: () {
            _setMapStyle('Light');
          },
        ),
        ListTile(
          leading: Icon(
            Icons.check_circle_outline,
            color: currentStyleItem == 'Outdoors'
                ? Colors.pink.shade600
                : Colors.grey[300],
          ),
          title: Text('Outdoors'),
          onTap: () {
            _setMapStyle('Outdoors');
          },
        ),
        ListTile(
          leading: Icon(
            Icons.check_circle_outline,
            color: currentStyleItem == 'Sattelite'
                ? Colors.pink.shade600
                : Colors.grey[300],
          ),
          title: Text('Sattelite'),
          onTap: () {
            _setMapStyle('Sattelite');
          },
        ),
      ],
    );
  }

  _setMapStyle(styleName) {
    setState(() {
      currentStyleItem = styleName;
      Navigator.pop(context);
      removeAllSymbols();
      Timer(Duration(milliseconds: 200), () {
        getPhotoPosts();
      });
    });
  }

  //----------------------------
  // show snackbar
  showSnackBar(text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: 1),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
