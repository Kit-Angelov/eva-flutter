import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:eva/screens/map/marker.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _mapStyle;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51.67204, 39.1843),
    zoom: 14.4746,
  );

  @override
  initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    Timer(
      Duration(seconds: 5),
      () async {
        var newMakres = await addMarker(markers);
        setState(() {
          markers = newMakres;
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          controller.setMapStyle(_mapStyle);
        },
        markers: Set<Marker>.of(markers.values),
        mapToolbarEnabled: false,
      )
    );
  }
}
