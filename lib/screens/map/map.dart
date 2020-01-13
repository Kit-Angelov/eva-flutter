import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:eva/screens/map/symbol.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final CameraPosition _kInitialPosition;
  static double defaultZoom = 13.0;

  CameraPosition _position;
  MapboxMapController mapController;
  bool _isMoving = false;
  bool _compassEnabled = true;
  MinMaxZoomPreference _minMaxZoomPreference =
      const MinMaxZoomPreference(1.0, 18.0);
  String _styleString = "mapbox://styles/mapbox/streets-v11";
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = false;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = false;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;

  _MapScreenState._(
      this._kInitialPosition, this._position);

  static CameraPosition _getCameraPosition() {
    final latLng = LatLng(51.67204, 39.1843);
    return CameraPosition(
      target: latLng,
      zoom: defaultZoom,
    );
  }

  factory _MapScreenState() {
    CameraPosition cameraPosition = _getCameraPosition();

    return _MapScreenState._(
        cameraPosition, cameraPosition);
  }

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  @override
  void dispose() {
    if (mapController != null) {
      mapController.removeListener(_onMapChanged);
    }
    super.dispose();
  }

  void _extractMapInfo() {
    _position = mapController.cameraPosition;
    _isMoving = mapController.isCameraMoving;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildMapBox(context),
    );
  }

  MapboxMap _buildMapBox(BuildContext context) {
    return MapboxMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: this._kInitialPosition,
        trackCameraPosition: true,
        compassEnabled: _compassEnabled,
        minMaxZoomPreference: _minMaxZoomPreference,
        styleString: _styleString,
        rotateGesturesEnabled: _rotateGesturesEnabled,
        scrollGesturesEnabled: _scrollGesturesEnabled,
        tiltGesturesEnabled: _tiltGesturesEnabled,
        zoomGesturesEnabled: _zoomGesturesEnabled,
        myLocationEnabled: _myLocationEnabled,
        myLocationTrackingMode: _myLocationTrackingMode,
        onCameraTrackingDismissed: () {
          this.setState(() {
            _myLocationTrackingMode = MyLocationTrackingMode.None;
          });
        });
  }

  Future<String> _findPath() async {
    final file = await DefaultCacheManager().getSingleFile('https://image.flaticon.com/icons/png/512/65/65000.png');
    return file.path;
  }

  Future<void> onMapCreated(MapboxMapController controller) async {
    mapController = controller;
    mapController.addListener(_onMapChanged);
    _extractMapInfo();
    // addSymbol(mapController, "lib/screens/map/baba.jpg", 51.67204, 39.1843);
    // mapController.addCircle(
    //   CircleOptions(
    //       geometry: LatLng(51.67204, 39.1843),
    //       circleColor: "#FF0000"),
    // );
    CachedNetworkImage(
      // placeholder: (context, url) => CircularProgressIndicator(),
      imageUrl: 'https://image.flaticon.com/icons/png/512/65/65000.png',
    );
    var imagePath = await _findPath();
    print(imagePath);
    print(File(imagePath).path);
    mapController.addSymbol(
      SymbolOptions(
        geometry: LatLng(51.67204, 39.1843),
        iconImage: 'file:/' + imagePath,
        // iconSize: iconSize,
      ),
    );
    setState(() {});
  }
}
