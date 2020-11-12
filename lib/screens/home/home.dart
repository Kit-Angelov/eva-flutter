import 'dart:async';
import 'dart:convert';

import 'package:eva/screens/home/modalSheets/userDetailWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:http/http.dart';

import 'package:eva/widgets/widgets.dart';
import 'package:eva/screens/home/modalSheets/placeSearchWidget.dart';
import 'package:eva/models/myCurrentLocation.dart';
import 'package:eva/screens/home/modalSheets/minPubWidget.dart';
import 'package:eva/services/firebaseAuth.dart';
import 'package:eva/config.dart';
import 'package:eva/models/profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //models
  var getPhotoState;

  final GlobalKey<MapWidgetState> _mapWidgetState = GlobalKey<MapWidgetState>();

  double bottomMargin = 0;

  Widget _userDetailWidget;
  Widget _getPhotoWidget;
  Widget _minPubWidget;

  Location location = new Location();

  Profile profileData;

  void _searchPlaceCallback(lat, lng) {
    // _mapWidgetState.currentState.setCameraPosition(lat, lng);
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
    setState(() {});
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
              Column(
                children: <Widget>[
                  Expanded(
                      child: MapWidget(
                          key: _mapWidgetState,
                          symbolClickCallBack: symbolClickCallBack)),
                ],
              ),
              Positioned(
                //search places
                bottom: bottomMargin + 165,
                right: 5,
                child: Opacity(
                  opacity: 0.9,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(44, 62, 80, 1), width: 1),
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Color.fromRGBO(44, 62, 80, 1),
                      ),
                      onPressed: () {
                        openPlaceSearch(context, _searchPlaceCallback);
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                //user avatar
                top: 30,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(44, 62, 80, 1),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: profileData != null
                            ? profileData.photo != ''
                                ? Image.network(
                                    profileData.photo + '/300.jpg',
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
                                    fit: BoxFit.cover,
                                  )
                            : Image.network(
                                'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
                                fit: BoxFit.cover,
                              )),
                  ),
                ),
              ),
              Positioned(
                // profile
                top: 30,
                left: 5,
                child: Opacity(
                  opacity: 0.9,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Color.fromRGBO(44, 62, 80, 1),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                // my position
                bottom: bottomMargin + 110,
                right: 5,
                child: Opacity(
                  opacity: 0.9,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(44, 62, 80, 1), width: 1),
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.my_location,
                        color: Color.fromRGBO(44, 62, 80, 1),
                      ),
                      onPressed: () {
                        _mapWidgetState.currentState.moveToLastKnownLocation();
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                // camera
                bottom: bottomMargin + 290,
                right: 5,
                child: Opacity(
                  opacity: 0.9,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink.shade600, width: 1),
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.camera,
                        color: Colors.pink.shade600,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/pubPhoto');
                      },
                    ),
                  ),
                ),
              ),
              (_minPubWidget == null) ? SizedBox() : _minPubWidget,
              (_userDetailWidget == null) ? SizedBox() : _userDetailWidget
            ].where(notNull).toList(),
          ),
        ));
  }

  // PubPhotoDetail

  void minPubWidgetClose() {
    setState(() {
      _minPubWidget = null;
    });
  }

  void symbolClickCallBack(symbolData) async {
    setState(() {
      _minPubWidget = new MinPubWidget(
          photoData: symbolData,
          closeCallback: minPubWidgetClose,
          showUserDetailCallback: showUserDetailWidget);
    });
  }

  // -----------

  // UserDetail

  void userDetailWidgetClose() {
    setState(() {
      _minPubWidget = null;
    });
  }

  void showUserDetailWidget(userId) {
    setState(() {
      _userDetailWidget = new UserDetailWidget(
          userId: userId, closeCallback: userDetailWidgetClose);
    });
  }

  // -----------

  // Profile
  Future<Response> _getProfileData(url) async {
    var res = await get(url);
    return res;
  }

  void getProfileData() async {
    String token;
    print("GET");
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['profile'] + '/?idToken=${token}';
      _getProfileData(url).then((res) {
        if (res.body != null && res.body != 'null') {
          print(res.body);
          profileData = Profile.fromJson(json.decode(res.body));
          if (profileData.photo != null) {
            setState(() {});
          }
        }
      });
    });
  }
  // -----------------
}
