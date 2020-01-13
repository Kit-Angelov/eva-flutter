import 'package:mapbox_gl/mapbox_gl.dart';


void addSymbol(MapboxMapController controller, String iconImageUrl, double lat, double lng, {double iconSize = 0.25}) {
    controller.addSymbol(
      SymbolOptions(
        geometry: LatLng(
          lat, lng
        ),
        iconImage: iconImageUrl,
        // iconSize: iconSize,
      ),
    );
  }