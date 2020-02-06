
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:geolocator/geolocator.dart';


class GeolocationSender {
  
}


void geolocationSend(WebSocketChannel channel, Position position) {
  channel.sink.add(position);
}
