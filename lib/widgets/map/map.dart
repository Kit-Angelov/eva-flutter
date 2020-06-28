import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:eva/services/firebaseAuth.dart';

import 'package:eva/widgets/map/marker.dart';
import 'package:eva/widgets/map/circle.dart';
import 'package:eva/models/photoPost.dart';


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

  List<PhotoPost> photoPosts;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51.67204, 39.1843),
    zoom: 11.4746,
  );

  void _onMapCreated(GoogleMapController controller) async  {
    mapController = controller;
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) async {
    LatLngBounds latLngBounds = await mapController.getVisibleRegion();
    widget.cameraMoveCallback(latLngBounds);
    getPhotoPosts();
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

  Future<http.Response> _getPhotoPosts(url) async{
    var res = await http.get(url);
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
