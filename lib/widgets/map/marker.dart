import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


Future<Map<MarkerId, Marker>> addMarker(Map<MarkerId, Marker> markers, lat, lng, id, imgSrc) async{
  final int targetWidth = 60;
  final File markerImageFile = await DefaultCacheManager().getSingleFile(imgSrc);
  final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
  
  final Codec markerImageCodec = await instantiateImageCodec(
    markerImageBytes,
    targetWidth: targetWidth,
  );
  final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
  final ByteData byteData = await frameInfo.image.toByteData(
    format: ImageByteFormat.png,
  );

  final Uint8List resizedMarkerImageBytes = byteData.buffer.asUint8List();

  var markerIdVal = id;
  final MarkerId markerId = MarkerId(markerIdVal);

  final Marker marker = Marker(
    markerId: markerId,
    position: LatLng(lat, lng),
    infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
    icon: BitmapDescriptor.fromBytes(resizedMarkerImageBytes),
    onTap: () {
      _onMarkerTapped(markerId);
    },
  );
  markers[markerId] = marker;
  return markers;
}

void _onMarkerTapped(markerId) {
  print(markerId);
}