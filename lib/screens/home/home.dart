import 'package:eva/utils/geolocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eva/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<MapWidgetState> _mapWidgetState = GlobalKey<MapWidgetState>();
  MapWidget map;
  GeolocationStatus geolocationStatus;
  Position myPosition;

  Future<void> _checkGeolocationPermissionStatus() async {
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
  }

  void _searchPlaceCallback(lat, lng) {
    _mapWidgetState.currentState.setCameraPosition(lat, lng);
  }
  
  void _updateMyLocationCallback(Position position) {
    setState(() {
      myPosition = position;
    });
  }

  void _moveToMyPosition() async{
    await getMyLocation(_updateMyLocationCallback);
    await _checkGeolocationPermissionStatus();
    if (geolocationStatus == GeolocationStatus.granted) {
      _mapWidgetState.currentState.setCameraPosition(myPosition.latitude, myPosition.longitude);
    }
  }

  void _openPlaceSearch() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
              child: Container(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text(
                          "search places",
                          style: TextStyle(color: Colors.black54, fontSize: 18,),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){Navigator.pop(context);},
                      child: Text(
                        "close",
                        style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w400,),
                      ),
                    )
                  ],
                ),
              ), 
            ),
            Divider(height: 0, thickness: 1, indent: 0, endIndent: 0),
            Expanded(
              child: SearchPlaceWidget(geocodingCallback: _searchPlaceCallback),
            )
          ],
        ),
        height: MediaQuery.of(context).size.height - 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
          )
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _moveToMyPosition();
    setState(() {
      map = MapWidget(key: _mapWidgetState);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Column(children: <Widget>[
              Expanded(child: map,),
            ],),
            Positioned(
              bottom: 30,
              left: 5,
              child: Opacity(
                opacity: 0.9,
                child: FloatingActionButton(
                  backgroundColor: Colors.purple.shade500,
                  child: Icon(Icons.search),
                  elevation: 0.0,
                  mini: false,
                  heroTag: null,
                  onPressed: (){_openPlaceSearch();},
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 5,
              child: 
              GestureDetector(
                onTap: (){print("to profile");},
                child: Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade500,
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/9/9a/Gull_portrait_ca_usa.jpg",
                      fit: BoxFit.cover,
                    )
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 5,
              child: Opacity(
                opacity: 0.9,
                child: FloatingActionButton(
                  backgroundColor: Colors.purple.shade500,
                  child: Icon(Icons.my_location),
                  elevation: 0.0,
                  mini: true,
                  heroTag: null,
                  onPressed: (){_moveToMyPosition();},
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
