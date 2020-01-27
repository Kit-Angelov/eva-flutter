import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


Future<Map<CircleId, Circle>> addCircle(Map<CircleId, Circle> circles, lat, lng) async{
  var circleIdVal = "1";
  final CircleId circleId = CircleId(circleIdVal);

  final Circle circle = Circle(
    circleId: circleId,
    center: LatLng(lat, lng),
    radius: 60,
    fillColor: Colors.red,
    onTap: () {
      _onCircleTapped(circleId);
    },
  );
  print("circle");
  circles[circleId] = circle;
  return circles;
}

void _onCircleTapped(circleId) {
  print(circleId);
}