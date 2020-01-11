import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';


class MapScreen extends StatelessWidget {

  @override
    Widget build(BuildContext context) {
    return new FlutterMap(
      options: new MapOptions(
        center: new LatLng(51.658, 39.233),
        zoom: 13.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.mapbox.com/styles/v1/kitangelov/cjzojp5lx0ajr1cntcuwaimnk/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2l0YW5nZWxvdiIsImEiOiJjamd1aHZncTMxMjF6MndtcWdjZGZhY2g1In0.s4vQ4pbKkTCpKt6psOPxMw",
          additionalOptions: {
            'id': 'mapbox.streets',
          },
        ),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 50.0,
              height: 50.0,
              point: new LatLng(51.658, 39.233),
              builder: (ctx) =>
              new Container(
                child: new FlutterLogo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}