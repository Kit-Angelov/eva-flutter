import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import 'package:eva/utils/geolocation.dart';
import 'package:eva/widgets/widgets.dart';
import 'package:eva/screens/home/modalSheets/modalBottomSheets.dart';
import 'package:eva/services/webSocketConnection.dart';
import 'package:eva/services/usersLocationGetter.dart';
import 'package:eva/models/myCurrentLocation.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //models
  var getPhotoState;
  var myCurrentLocationState;

  final GlobalKey<MapWidgetState> _mapWidgetState = GlobalKey<MapWidgetState>();

  GeolocationStatus geolocationStatus;
  Position myPosition;

  WebSocketConnection geolocationSender;
  var userLocationGetter;

  double bottomMargin = 0;

  Widget _userDetailWidget;
  Widget _getPhotoWidget;

  var currentAppIndex = 0;
  Map appsIcons = {
    0: Icons.person_pin,
    1: Icons.photo_library
  };


  checkGeolocationPermissionStatus() async{
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
    setState(() {});
  }

  void _selectAppCallback(index) {
    Navigator.pop(context);
    setState(() {
      currentAppIndex = index;
    });
  }

  void _searchPlaceCallback(lat, lng) {
    // _mapWidgetState.currentState.setCameraPosition(lat, lng);
  }

  void _setMyPositionToMap() {
    // _mapWidgetState.currentState.setMyPosition(myPosition.latitude, myPosition.longitude);
  }
  
  void _updateMyLocationCallback(Position position) {
    setState(() {
      myCurrentLocationState.setMyCurrentLocation(position);
      myPosition = position;
      // _setMyPositionToMap();
      // geolocationSender.send(myPosition.toJson());
    });
  }

  void _initGettingMyPosition() async {
    updateMyLocation(_updateMyLocationCallback);
  }

  Future<void> _moveToMyPosition() async{
    await checkGeolocationPermissionStatus();
    await getMyLocation(_updateMyLocationCallback);
    if (geolocationStatus == GeolocationStatus.granted && myPosition != null) {
      // _mapWidgetState.currentState.setCameraPosition(myPosition.latitude, myPosition.longitude);
    }
  }

  void cameraMoveCallBack(bbox) {
    // userLocationGetter.updateBbox(bbox);
  }

  @override
  void initState() {
    super.initState();
    _initGettingMyPosition();
    // geolocationSender = new WebSocketConnection("ws://192.168.0.105:8001");
    // geolocationSender.connect();
    // userLocationGetter = UsersLocationGetter(_mapWidgetState);
    // userLocationGetter.consume();
    setState(() {});
  }

  bool notNull(Object o) => o != null;
  @override
  Widget build(BuildContext context) {
    myCurrentLocationState = Provider.of<MyCurrentLocationModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Column(children: <Widget>[
              Expanded(child: MapWidget(),)
            ],),
            Positioned( //search places
              bottom: bottomMargin + 30,
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
            Positioned( //user avatar
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
            Positioned( // my position
              bottom: bottomMargin + 30,
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
            // Positioned( // app list
            //   bottom: bottomMargin + 150,
            //   right: 5,
            //   child: Opacity(
            //     opacity: 0.9,
            //     child: FloatingActionButton(
            //       backgroundColor: Colors.purple.shade500,
            //       child: Icon(appsIcons[currentAppIndex]),
            //       elevation: 0.0,
            //       mini: true,
            //       heroTag: null,
            //       onPressed: (){openAppsList(context, _selectAppCallback);},
            //     ),
            //   ),
            // ),
            // Positioned( // favorits
            //   bottom: bottomMargin + 220,
            //   right: 5,
            //   child: Opacity(
            //     opacity: 0.9,
            //     child: FloatingActionButton(
            //       backgroundColor: Colors.purple.shade500,
            //       child: Icon(Icons.favorite_border),
            //       elevation: 0.0,
            //       mini: true,
            //       heroTag: null,
            //       onPressed: (){
            //         _userDetailWidget = UserDetailWidget(userId: "asdf");
            //         bottomMargin = 60;
            //         setState(() {});
            //       },
            //     ),
            //   ),
            // ),
            // (currentAppIndex == 1) ? 
            Positioned( // camera
                bottom: bottomMargin + 290,
                right: 5,
                child: Opacity(
                  opacity: 0.9,
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple.shade500,
                    child: Icon(Icons.camera),
                    elevation: 0.0,
                    mini: true,
                    heroTag: null,
                    onPressed: (){
                      checkGeolocationPermissionStatus();
                      Navigator.pushNamed(context, '/pubPhoto');
                    },
                  ),
                ),
              ),
            // : null,
            // (_userDetailWidget == null) ? SizedBox() : _userDetailWidget
          ].where(notNull).toList(),
        ),
      )
    );
  }
}
