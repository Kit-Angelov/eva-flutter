import 'dart:convert';
import 'dart:async';

import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:eva/config.dart';
import 'package:eva/services/webSocketConnection.dart';

class UsersLocationGetter {
  var mapWidget;
  var geolocationReceiver;
  var run = true;
  var bbox = {
    "leftBottomLat": 0.0,
    "leftBottomLng": 0.0,
    "rightTopLat": 0.0,
    "rightTopLng": 0.0,
  };
  var changeBbox = false;

  UsersLocationGetter(this.mapWidget);

  void updateBbox(LatLngBounds latLngBounds) {
    bbox = {
      "leftBottomLat": latLngBounds.southwest.latitude,
      "leftBottomLng": latLngBounds.southwest.longitude,
      "rightTopLat": latLngBounds.northeast.latitude,
      "rightTopLng": latLngBounds.northeast.longitude,
    };
    changeBbox = true;
  }

  Future<void> consume() async {
    while (run) {
      changeBbox = false;
      connect();
      while (geolocationReceiver.state != 2) {
        if (changeBbox == true) {
          break;
        }
        await new Future.delayed(const Duration(milliseconds: 1000));
      }
      for (var i = 0; i < 5; i++) {
        if (changeBbox == true) {
          break;
        }
        await new Future.delayed(const Duration(milliseconds: 1000));
      }
    }
  }

  Future<void> connect() async {
    geolocationReceiver = WebSocketConnection(config.urls['userLocationGetter'],
        urlParams: bbox, messageHandle: messageHandle);
    geolocationReceiver.connect();
  }

  void messageHandle(jsonData) {
    var data = jsonDecode(jsonData);
    mapWidget.currentState.addUserMarker(
        data['location']['coordinates'][1],
        data['location']['coordinates'][0],
        data['userId'],
        "https://image.flaticon.com/icons/png/512/65/65000.png");
  }
}
