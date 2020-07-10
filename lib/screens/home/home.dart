import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

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

  // WebSocketConnection geolocationSender;
  // var userLocationGetter;

  double bottomMargin = 0;

  Widget _userDetailWidget;
  Widget _getPhotoWidget;

  Location location = new Location();


  // checkGeolocationPermissionStatus() async{
  //   geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
  //   setState(() {});
  // }

  void _searchPlaceCallback(lat, lng) {
    // _mapWidgetState.currentState.setCameraPosition(lat, lng);
  }
  
  // void _updateMyLocationCallback(Position position) {
  //   setState(() {
  //     myCurrentLocationState.setMyCurrentLocation(position);
  //     myPosition = position;
  //     // _setMyPositionToMap();
  //     // geolocationSender.send(myPosition.toJson());
  //   });
  // }

  // void _initGettingMyPosition() async {
  //   updateMyLocation(_updateMyLocationCallback);
  // }

  // void cameraMoveCallBack(bbox) {
  //   // userLocationGetter.updateBbox(bbox);
  // }

  @override
  void initState() {
    super.initState();
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
              Expanded(child: MapWidget(key: _mapWidgetState)),
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
                  onPressed: (){_mapWidgetState.currentState.moveToMyPosition();},
                ),
              ),
            ),
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
                      // checkGeolocationPermissionStatus();
                      Navigator.pushNamed(context, '/pubPhoto');
                    },
                  ),
                ),
              ),
            // (_photoDetailWidget == null) ? SizedBox() : _photoDetailWidget
          ].where(notNull).toList(),
        ),
      )
    );
  }
}
