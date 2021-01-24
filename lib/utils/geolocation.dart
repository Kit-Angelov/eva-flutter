import 'dart:async';

import 'package:geolocator/geolocator.dart';

Future<void> getMyLocation(callback) async {
  Position myPosition;
  try {
    myPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    callback(myPosition);
  } catch (error) {}
}

StreamSubscription<Position> updateMyLocation(callback) {
  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  StreamSubscription<Position> positionStream =
      geolocator.getPositionStream(locationOptions).listen((Position position) {
    callback(position);
  });
  return positionStream;
}
