import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  Widget build(BuildContext context) {
    return new FlutterMap(
      options: new MapOptions(
        center: new LatLng(51.5, -0.09),
        zoom: 13.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.mapbox.com/styles/v1/kitangelov/cjzojp5lx0ajr1cntcuwaimnk/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2l0YW5nZWxvdiIsImEiOiJjamd1aHZncTMxMjF6MndtcWdjZGZhY2g1In0.s4vQ4pbKkTCpKt6psOPxMw",
          additionalOptions: {
            'accessToken': 'pk.eyJ1Ijoia2l0YW5nZWxvdiIsImEiOiJjamd1aHZncTMxMjF6MndtcWdjZGZhY2g1In0.s4vQ4pbKkTCpKt6psOPxMw',
            'id': 'mapbox.streets',
          },
        ),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 80.0,
              height: 80.0,
              point: new LatLng(51.5, -0.09),
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
