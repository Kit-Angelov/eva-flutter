import 'dart:async';
import 'package:eva/utils/geolocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eva/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:eva/screens/home/modalSheets/modalBottomSheets.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<MapWidgetState> _mapWidgetState = GlobalKey<MapWidgetState>();
  MapWidget map;
  GeolocationStatus geolocationStatus;
  Position myPosition;
  var currentAppIndex = 0;
  Map appsIcons = {
    0: Icons.person_pin,
    1: Icons.photo_library
  };

  void _selectAppCallback(index) {
    Navigator.pop(context);
    setState(() {
      currentAppIndex = index;
    });
  }

  Future<void> _checkGeolocationPermissionStatus() async {
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
  }

  void _searchPlaceCallback(lat, lng) {
    _mapWidgetState.currentState.setCameraPosition(lat, lng);
  }

  void _setMyPositionToMap() {
    _mapWidgetState.currentState.setMyPosition(myPosition.latitude, myPosition.longitude);
  }
  
  void _updateMyLocationCallback(Position position) {
    setState(() {
      myPosition = position;
      _setMyPositionToMap();
    });
  }

  void _initGettingMyPosition() async{
    await _moveToMyPosition();
    updateMyLocation(_updateMyLocationCallback);
  }

  Future<void> _moveToMyPosition() async{
    await getMyLocation(_updateMyLocationCallback);
    await _checkGeolocationPermissionStatus();
    if (geolocationStatus == GeolocationStatus.granted && myPosition != null) {
      _mapWidgetState.currentState.setCameraPosition(myPosition.latitude, myPosition.longitude);
    }
  }

  @override
  void initState() {
    super.initState();
    _initGettingMyPosition();
    setState(() {
      map = MapWidget(key: _mapWidgetState);
    });
  }

  bool notNull(Object o) => o != null;
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
                child: FlatButton.icon(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  color: Colors.purple.shade500,
                  textColor: Colors.white,
                  icon: Icon(Icons.search),
                  label: Text(
                    "places".toUpperCase(),
                    style: TextStyle(fontSize: 18),  
                  ),
                  onPressed: (){openPlaceSearch(context, _searchPlaceCallback);},
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 5,
              child: 
              GestureDetector(
                onTap: (){Navigator.pushNamed(context, '/profile');},
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
            Positioned(
              bottom: 150,
              right: 5,
              child: Opacity(
                opacity: 0.9,
                child: FloatingActionButton(
                  backgroundColor: Colors.purple.shade500,
                  child: Icon(appsIcons[currentAppIndex]),
                  elevation: 0.0,
                  mini: true,
                  heroTag: null,
                  onPressed: (){openAppsList(context, _selectAppCallback);},
                ),
              ),
            ),
            Positioned(
              bottom: 220,
              right: 5,
              child: Opacity(
                opacity: 0.9,
                child: FloatingActionButton(
                  backgroundColor: Colors.purple.shade500,
                  child: Icon(Icons.favorite_border),
                  elevation: 0.0,
                  mini: true,
                  heroTag: null,
                  onPressed: (){openAppsList(context, _selectAppCallback);},
                ),
              ),
            ),
            currentAppIndex == 1
            ? Positioned(
                bottom: 290,
                right: 5,
                child: Opacity(
                  opacity: 0.9,
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple.shade500,
                    child: Icon(Icons.camera),
                    elevation: 0.0,
                    mini: true,
                    heroTag: null,
                    // onPressed: (){openAppsList(context, _selectAppCallback);},
                  ),
                ),
              )
            : null
          ].where(notNull).toList(),
        ),
      )
    );
  }
}
