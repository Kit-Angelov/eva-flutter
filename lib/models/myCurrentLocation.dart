import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyCurrentLocationModel extends ChangeNotifier{
  Position myCurrentLocation;

  void setMyCurrentLocation(Position location) {
    myCurrentLocation = location;
    notifyListeners();
  }

  Position getMyCurrentLocation() {
    return myCurrentLocation;
  }
}