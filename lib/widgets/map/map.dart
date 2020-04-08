import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:eva/widgets/map/marker.dart';
import 'package:eva/widgets/map/circle.dart';


class MapWidget extends StatefulWidget {
  var cameraMoveCallback;
  MapWidget({Key key, this.cameraMoveCallback}) : super(key: key);

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51.67204, 39.1843),
    zoom: 14.4746,
  );

  void _onMapCreated(GoogleMapController controller) async  {
    mapController = controller;
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) async {
    LatLngBounds latLngBounds = await mapController.getVisibleRegion();
    widget.cameraMoveCallback(latLngBounds);
  }

  Future<void> setCameraPosition(lat, lng) async{
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(lat, lng),
        zoom: 17,
      )
    ));
  }

  void addUserMarker(lat, lng, id, imgSrc) async {
    var newMarkers = await addMarker(markers, lat, lng, id, imgSrc);
    setState(() {
      markers = newMarkers;
    });
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
        onMapCreated: _onMapCreated,
        onCameraMove: _onCameraMove,
        markers: Set<Marker>.of(markers.values),
        circles: Set<Circle>.of(circles.values),
        mapToolbarEnabled: false,
        compassEnabled: false
      ),
    );
  }
}
