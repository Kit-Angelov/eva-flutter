import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:eva/widgets/map/marker.dart';
import 'package:eva/widgets/map/circle.dart';


class MapWidget extends StatefulWidget {
  MapWidget({Key key}) : super(key: key);

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{}; 

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

  void setMyPosition(lat, lng) async{
    var newCircles = await addCircle(circles, lat, lng);
    setState(() {
      circles = newCircles;
    });
  }

  @override
  initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values),
        circles: Set<Circle>.of(circles.values),
        mapToolbarEnabled: false,
        compassEnabled: false
      ),
    );
  }
}
