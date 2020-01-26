import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:eva/widgets/map/marker.dart';


class MapWidget extends StatefulWidget {
  MapWidget({Key key}) : super(key: key);

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  GoogleMap _map;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51.67204, 39.1843),
    zoom: 14.4746,
  );

  Future<void> setCameraPosition(lat, lng) async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(lat, lng),
        zoom: 17,
      )
    ));
  }

  void _initMap() {
    _map = GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: Set<Marker>.of(markers.values),
      mapToolbarEnabled: false,
      compassEnabled: false
    );
  }

  @override
  initState() {
    super.initState();
    _initMap();
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
      body: _map,
    );
  }
}
