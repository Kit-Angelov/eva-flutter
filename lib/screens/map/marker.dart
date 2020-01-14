import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MarkerController
  Future<void> addMarker(Map<MarkerId, Marker> markers, ) async{
    final int targetWidth = 60;
    final File markerImageFile = await DefaultCacheManager().getSingleFile("https://image.flaticon.com/icons/png/512/65/65000.png");
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

    var markerIdVal = "1";
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(51.67204, 39.1843),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      icon: BitmapDescriptor.fromBytes(resizedMarkerImageBytes),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );
  }

  void _onMarkerTapped(markerId) {
    print(markerId);
  }