import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:http/http.dart';

import 'package:eva/screens/profile/enterUsername.dart';
import 'package:eva/screens/home/modalSheets/userDetailWidget.dart';
import 'package:eva/widgets/widgets.dart';
import 'package:eva/screens/home/modalSheets/placeSearchWidget.dart';
import 'package:eva/models/photoData.dart';
import 'package:eva/models/photoPost.dart';
import 'package:eva/screens/home/modalSheets/minPubWidget.dart';
import 'package:eva/services/firebaseAuth.dart';
import 'package:eva/config.dart';
import 'package:eva/models/profile.dart';
import 'package:eva/screens/pubPhotoDetail/pubPhotoDetail.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool load = false;

  BuildContext currentContext;

  //models
  var getPhotoState;

  final GlobalKey<MapWidgetState> _mapWidgetState = GlobalKey<MapWidgetState>();

  Widget _userDetailWidget;
  Widget _minPubWidget;

  Location location = new Location();

  Profile profileData;
  Profile userData;
  int userFilterIndex = 0;

  void _searchPlaceCallback(latLng) {
    _mapWidgetState.currentState.animateCameraPosition(latLng, zoom: 11);
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
    currentContext = context;
    return load == false
        ? LoadWidget()
        : Scaffold(
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
                    top: 400,
                    right: 5,
                    child: Opacity(
                      opacity: 0.9,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white38, width: 2),
                          color: Color.fromRGBO(44, 62, 80, 1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            openPlaceSearch(context, _searchPlaceCallback);
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    //filter user
                    top: 30,
                    right: 5,
                    child: GestureDetector(
                        onTap: () {
                          setFilterUser();
                        },
                        child: getFilterLabelWidget()),
                  ),
                  Positioned(
                    // profile
                    top: 30,
                    left: 5,
                    child: Opacity(
                      opacity: 0.9,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(44, 62, 80, 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
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
                    top: 450,
                    right: 5,
                    child: Opacity(
                      opacity: 0.9,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white38, width: 2),
                          color: Color.fromRGBO(44, 62, 80, 1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.my_location, color: Colors.white),
                          onPressed: () {
                            toMyLocation();
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // camera
                    top: 300,
                    right: 5,
                    child: Opacity(
                      opacity: 0.9,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.pink.shade600, width: 1),
                          color: Colors.pink.shade600,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            pushToPubNewPhoto();
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

  // check location

  void toMyLocation() async {
    final location = Location();
    final hasPermissions = await location.hasPermission();
    if (hasPermissions != PermissionStatus.granted) {
      showAlertLocationDialog(
          context, 'Location request', 'Allow to request my location');
    } else {
      _mapWidgetState.currentState.moveToLastKnownLocation();
    }
  }

  void pushToPubNewPhoto() async {
    final location = Location();
    final hasPermissions = await location.hasPermission();
    if (hasPermissions != PermissionStatus.granted) {
      showAlertLocationDialog(
          context, 'Location request', 'Allow to request my location');
    } else {
      Navigator.pushNamed(context, '/pubPhoto')
          .then((value) => getPhotoPosts());
    }
  }

  // PubPhotoDetail

  void minPubWidgetClose() {
    setState(() {
      _minPubWidget = null;
    });
  }

  void openDetailCallback() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PubPhotoDetailScreen(
          setFilterUserCallback: setFilterUserCallback,
        ),
      ),
    ).then((value) => getPhotoPosts());
    minPubWidgetClose();
  }

  void symbolClickCallBack(symbolData) async {
    setState(() {
      Provider.of<PhotoDataModel>(currentContext)
          .setPhotoData(PhotoPost.fromSymbolData(symbolData));
      _minPubWidget = new MinPubWidget(
        closeCallback: minPubWidgetClose,
        openDetailCallback: openDetailCallback,
      );
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
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['profile'] + '?idToken=${token}';
      _getProfileData(url).then((res) {
        if (res.body != null && res.body != 'null') {
          profileData =
              Profile.fromJson(json.decode(utf8.decode(res.bodyBytes)));
          var username = profileData.username;
          if (username == null || username == '' || username == ' ') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EnterUsernameScreen(
                  currentUsername: '',
                  successPushName: '/',
                ),
              ),
            );
          }
          if (profileData.photo != null) {
            setState(() {
              load = true;
            });
          }
        }
      }).catchError((e) {});
    });
  }

  // -----------------
  // LOCATION ALERT DIALOG
  showAlertLocationDialog(BuildContext context, String title, String content) {
    Widget ok = FlatButton(
      child: Text('Ok'),
      onPressed: () {
        location.requestPermission();
        Navigator.pop(context);
      },
    );
    Widget cancel = FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [ok, cancel],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  //------------------
  // set filter user

  void setFilterUserCallback(Profile userData) {
    if (userData.userId != profileData.userId) {
      setFilterUser(newUserData: userData);
    }
  }

  void setFilterUser({Profile newUserData}) {
    if (newUserData != null) {
      setState(() {
        userData = newUserData;
        userFilterIndex = 2;
      });
    } else {
      setState(() {
        if (userFilterIndex == 0) {
          userFilterIndex = 1;
        } else if (userFilterIndex == 1) {
          if (userData != null) {
            userFilterIndex = 2;
          } else {
            userFilterIndex = 0;
          }
        } else if (userFilterIndex == 2) {
          userFilterIndex = 0;
        }
      });
    }
    getPhotoPosts();
  }

  getPhotoPosts() {
    _mapWidgetState.currentState.removeAllSymbols();
    if (userFilterIndex == 0) {
      _mapWidgetState.currentState.showSnackBar('All posts');
      Timer(Duration(milliseconds: 200), () {
        _mapWidgetState.currentState.getPhotoPosts();
      });
    } else if (userFilterIndex == 1) {
      _mapWidgetState.currentState.showSnackBar('My posts');
      Timer(Duration(milliseconds: 200), () {
        _mapWidgetState.currentState.getPhotoPosts(profile: profileData);
      });
    } else {
      _mapWidgetState.currentState.showSnackBar('User posts');
      Timer(Duration(milliseconds: 200), () {
        _mapWidgetState.currentState.getPhotoPosts(profile: userData);
      });
    }
  }

  getFilterLabelWidget() {
    var labelWidget;
    if (userFilterIndex == 0) {
      labelWidget = Container(
          child: Icon(
        Icons.all_inclusive,
        color: Colors.white,
        size: 20,
      ));
    } else if (userFilterIndex == 1) {
      if (profileData != null) {
        if (profileData.photo != null) {
          labelWidget = Image.network(
              config.urls['media'] + profileData.photo + '/300.jpg',
              fit: BoxFit.cover);
        } else {
          labelWidget = SizedBox();
        }
      } else {
        labelWidget = SizedBox();
      }
    } else if (userFilterIndex == 2) {
      if (userData != null) {
        if (userData.photo != null) {
          labelWidget = Image.network(
              config.urls['media'] + userData.photo + '/300.jpg',
              fit: BoxFit.cover);
        } else {
          labelWidget = SizedBox();
        }
      } else {
        labelWidget = SizedBox();
      }
    }

    return Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Color.fromRGBO(44, 62, 80, 1),
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(25), child: labelWidget));
  }
  //------------------
}
